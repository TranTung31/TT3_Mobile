using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Settings;

namespace SystemService.Infrastructure.Workers;

/// <summary>
/// Worker dọn dẹp định kỳ bảng RefreshToken:
/// xoá các token đã hết hạn hoặc đã bị thu hồi (không còn dùng được) để tránh bảng phình to theo thời gian.
/// </summary>
public class RefreshTokenCleanupWorker : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly IOptions<RefreshTokenCleanupOptions> _options;
    private readonly ILogger<RefreshTokenCleanupWorker> _logger;

    public RefreshTokenCleanupWorker(
        IServiceScopeFactory scopeFactory,
        IOptions<RefreshTokenCleanupOptions> options,
        ILogger<RefreshTokenCleanupWorker> logger)
    {
        _scopeFactory = scopeFactory;
        _options = options;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var options = _options.Value;

        if (!options.Enabled)
        {
            _logger.LogInformation("Worker dọn RefreshToken bị tắt (RefreshTokenCleanup:Enabled = false).");
            return;
        }

        // Interval <= 0 -> fallback về 1 giờ cho an toàn.
        var interval = options.IntervalMinutes > 0
            ? TimeSpan.FromMinutes(options.IntervalMinutes)
            : TimeSpan.FromHours(1);

        using var timer = new PeriodicTimer(interval);

        _logger.LogInformation("Worker dọn RefreshToken bắt đầu, chu kỳ {IntervalMinutes} phút.", interval.TotalMinutes);

        try
        {
            // Chạy 1 lần ngay khi khởi động để dọn lượng token tồn đọng, sau đó chạy theo chu kỳ.
            do
            {
                try
                {
                    await CleanupAsync(stoppingToken);
                }
                catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
                {
                    break;
                }
                catch (Exception ex)
                {
                    // Lỗi tạm thời (mất kết nối DB...) không được làm chết worker — chờ chu kỳ sau.
                    _logger.LogError(ex, "Lỗi khi dọn dẹp RefreshToken, sẽ thử lại ở chu kỳ tiếp theo.");
                }
            }
            while (await timer.WaitForNextTickAsync(stoppingToken));
        }
        catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
        {
            // Shutdown bình thường của host.
        }

        _logger.LogInformation("Worker dọn RefreshToken dừng.");
    }

    private async Task CleanupAsync(CancellationToken cancellationToken)
    {
        // BackgroundService là singleton, còn DbContext/Repository là scoped
        // -> phải resolve chúng trong một scope riêng cho mỗi lần chạy.
        await using var scope = _scopeFactory.CreateAsyncScope();
        var refreshTokenRepository = scope.ServiceProvider.GetRequiredService<IRefreshTokenRepository>();

        var deletedExpired = await refreshTokenRepository.DeleteExpiredAsync(cancellationToken);
        var deletedRevoked = await refreshTokenRepository.DeleteRevokedAsync(cancellationToken);

        if (deletedExpired > 0 || deletedRevoked > 0)
        {
            _logger.LogInformation(
                "Đã dọn dẹp RefreshToken: {DeletedExpired} token hết hạn, {DeletedRevoked} token đã thu hồi.",
                deletedExpired, deletedRevoked);
        }
    }
}
