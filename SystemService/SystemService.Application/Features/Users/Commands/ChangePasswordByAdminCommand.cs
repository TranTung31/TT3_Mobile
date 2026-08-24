using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Users;
using SystemService.Domain;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Commands;

public record ChangePasswordByAdminCommand(ChangePasswordByAdminModel Model) : IRequest<Guid>;

public class ChangePasswordByAdminCommandHandler : IRequestHandler<ChangePasswordByAdminCommand, Guid>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<ChangePasswordByAdminCommandHandler> _logger;

    public ChangePasswordByAdminCommandHandler(
        UserManager<ApplicationUser> userManager,
        IRefreshTokenRepository refreshTokenRepository,
        IUnitOfWork unitOfWork,
        ILogger<ChangePasswordByAdminCommandHandler> logger)
    {
        _userManager = userManager;
        _refreshTokenRepository = refreshTokenRepository;
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<Guid> Handle(ChangePasswordByAdminCommand request, CancellationToken cancellationToken)
    {
        var model = request.Model;

        // 1. Tìm user mục tiêu theo Id (ASP.NET Identity)
        var user = await _userManager.FindByIdAsync(model.userId.ToString());
        if (user == null || user.IsDeleted)
            throw new NotFoundException(nameof(ApplicationUser), model.userId);

        // 2. Admin reset mật khẩu — không cần mật khẩu cũ
        var resetToken = await _userManager.GeneratePasswordResetTokenAsync(user);
        var result = await _userManager.ResetPasswordAsync(user, resetToken, model.NewPassword);
        if (!result.Succeeded)
            throw new BadRequestException(
                string.Join("; ", result.Errors.Select(e => e.Description)));

        // 3. Thu hồi refresh token để user phải đăng nhập lại
        await RevokeRefreshTokensAsync(user.Id, cancellationToken);

        _logger.LogInformation("Admin đã reset mật khẩu của user {UserId}.", user.Id);

        return user.Id;
    }

    private async Task RevokeRefreshTokensAsync(Guid userId, CancellationToken cancellationToken)
    {
        foreach (var refreshToken in await _refreshTokenRepository.GetActiveByUserIdAsync(userId, cancellationToken))
            _refreshTokenRepository.Revoke(refreshToken);

        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }
}
