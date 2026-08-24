using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Users;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Commands;

public record ChangePasswordCommand(ChangePasswordModel Model) : IRequest<Guid>;

public class ChangePasswordCommandHandler : IRequestHandler<ChangePasswordCommand, Guid>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ICurrentUserService _currentUserService;
    private readonly ILogger<ChangePasswordCommandHandler> _logger;

    public ChangePasswordCommandHandler(
        UserManager<ApplicationUser> userManager,
        IRefreshTokenRepository refreshTokenRepository,
        IUnitOfWork unitOfWork,
        ICurrentUserService currentUserService,
        ILogger<ChangePasswordCommandHandler> logger)
    {
        _userManager = userManager;
        _refreshTokenRepository = refreshTokenRepository;
        _unitOfWork = unitOfWork;
        _currentUserService = currentUserService;
        _logger = logger;
    }

    public async Task<Guid> Handle(ChangePasswordCommand request, CancellationToken cancellationToken)
    {
        var model = request.Model;

        // 1. Lấy user đang đăng nhập (ASP.NET Identity)
        var userId = _currentUserService.GetUserId();
        if (userId == null)
            throw new UnauthorizedException("Bạn chưa đăng nhập.");

        var user = await _userManager.FindByIdAsync(userId.Value.ToString());
        if (user == null || user.IsDeleted)
            throw new NotFoundException(nameof(ApplicationUser), userId.Value);

        // 2. Đổi mật khẩu — ChangePasswordAsync tự kiểm tra mật khẩu cũ
        var result = await _userManager.ChangePasswordAsync(user, model.OldPassword, model.NewPassword);
        if (!result.Succeeded)
            throw new BadRequestException(
                string.Join("; ", result.Errors.Select(e => e.Description)));

        // 3. Thu hồi refresh token để các phiên cũ phải đăng nhập lại
        await RevokeRefreshTokensAsync(user.Id, cancellationToken);

        _logger.LogInformation("User {UserId} đã đổi mật khẩu.", user.Id);

        return user.Id;
    }

    private async Task RevokeRefreshTokensAsync(Guid userId, CancellationToken cancellationToken)
    {
        foreach (var refreshToken in await _refreshTokenRepository.GetActiveByUserIdAsync(userId, cancellationToken))
            _refreshTokenRepository.Revoke(refreshToken);

        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }
}
