using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Shared.Redis.Permissions;
using Shared.Security;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Auth;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Entities.Auth;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Auth.Commands;

public record RefreshTokenCommand(string RefreshToken) : IRequest<AuthTokenResponse>;

public class RefreshTokenCommandHandler : IRequestHandler<RefreshTokenCommand, AuthTokenResponse>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ITokenService _tokenService;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IApplicationUserRoleRepository _userRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly IUnitOfWork _unitOfWork;
    private readonly JwtSettings _jwtSettings;
    private readonly ILogger<RefreshTokenCommandHandler> _logger;

    public RefreshTokenCommandHandler(
        UserManager<ApplicationUser> userManager,
        ITokenService tokenService,
        IRefreshTokenRepository refreshTokenRepository,
        IApplicationUserRoleRepository userRoleRepository,
        IRolePermissionRepository rolePermissionRepository,
        IUserPermissionCacheService userPermissionCacheService,
        IUnitOfWork unitOfWork,
        IOptions<JwtSettings> jwtSettings,
        ILogger<RefreshTokenCommandHandler> logger)
    {
        _userManager = userManager;
        _tokenService = tokenService;
        _refreshTokenRepository = refreshTokenRepository;
        _userRoleRepository = userRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _userPermissionCacheService = userPermissionCacheService;
        _unitOfWork = unitOfWork;
        _jwtSettings = jwtSettings.Value;
        _logger = logger;
    }

    public async Task<AuthTokenResponse> Handle(RefreshTokenCommand request, CancellationToken cancellationToken)
    {
        // 1. Tra cứu refresh token theo hash + kiểm tra hạn dùng / chưa bị thu hồi
        var stored = await _refreshTokenRepository.GetByTokenHashAsync(
            RefreshTokenHelper.Hash(request.RefreshToken), cancellationToken);
        if (stored == null || !stored.IsActive)
            throw new UnauthorizedException("Refresh token không hợp lệ hoặc đã hết hạn.");

        // 2. Tìm user và kiểm tra trạng thái tài khoản
        var user = await _userManager.FindByIdAsync(stored.UserId.ToString());
        if (user == null || user.IsDeleted)
            throw new UnauthorizedException("Người dùng không tồn tại.");

        if (await _userManager.IsLockedOutAsync(user))
            throw new UnauthorizedException("Tài khoản đã bị khóa.");

        // 3. Phát hành access token mới
        var token = await _tokenService.CreateTokenAsync(user, cancellationToken);

        // 4. Rotate refresh token: thu hồi token cũ, cấp token mới
        var newRefreshToken = RefreshTokenHelper.Generate();
        _refreshTokenRepository.Revoke(stored);
        await _refreshTokenRepository.InsertAsync(new RefreshToken
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            TokenHash = RefreshTokenHelper.Hash(newRefreshToken),
            ExpiresAtUtc = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpirationDays),
            CreatedOnUtc = DateTime.UtcNow
        }, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // 5. Load permissions + refresh cache Redis
        var permissions = await LoadUserPermissionsFromDbAsync(user.Id, cancellationToken);
        //await _userPermissionCacheService.SetPermissionsAsync(user.Id, permissions, cancellationToken: cancellationToken);

        // 6. Trả về token mới
        return new AuthTokenResponse
        {
            AccessToken = token.AccessToken,
            RefreshToken = newRefreshToken,
            ExpiresIn = token.ExpiresIn,
            UserId = user.Id,
            UserName = user.UserName,
            FullName = user.FullName,
            DonViId = user.DonViId,
            IsSuperAdmin = user.IsSuperAdmin,
            Roles = (await _userManager.GetRolesAsync(user)).ToList(),
            Permissions = permissions.ToList()
        };
    }

    private async Task<IReadOnlyCollection<string>> LoadUserPermissionsFromDbAsync(
        Guid userId,
        CancellationToken cancellationToken)
    {
        var roles = await _userRoleRepository.GetRolesByUserIdAsync(userId, cancellationToken);
        var permissions = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var role in roles)
        {
            var rolePermissions = await _rolePermissionRepository.GetPermissionsByRoleIdAsync(role.Id, cancellationToken);
            foreach (var permission in rolePermissions)
                if (!string.IsNullOrWhiteSpace(permission.Name))
                    permissions.Add(permission.Name);
        }

        return permissions.ToArray();
    }
}
