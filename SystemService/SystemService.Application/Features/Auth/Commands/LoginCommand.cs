using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Shared.Redis.Permissions;
using Shared.Security;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Auth;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Entities.Auth;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Auth.Commands;

public class LoginCommand : IRequest<AuthTokenResponse>
{
    public string UserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class LoginCommandHandler : IRequestHandler<LoginCommand, AuthTokenResponse>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ITokenService _tokenService;
    private readonly IAuthenticationService _authenticationService;
    private readonly IUserRepository _userRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly IApplicationUserRoleRepository _applicationUserRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly JwtSettings _jwtSettings;
    private readonly ILogger<LoginCommandHandler> _logger;

    public LoginCommandHandler(
        UserManager<ApplicationUser> userManager,
        ITokenService tokenService,
        IAuthenticationService authenticationService,
        IUserRepository userRepository,
        IUnitOfWork unitOfWork,
        IApplicationUserRoleRepository applicationUserRoleRepository,
        IRolePermissionRepository rolePermissionRepository,
        IUserPermissionCacheService userPermissionCacheService,
        IRefreshTokenRepository refreshTokenRepository,
        IOptions<JwtSettings> jwtSettings,
        ILogger<LoginCommandHandler> logger)
    {
        _userManager = userManager;
        _tokenService = tokenService;
        _authenticationService = authenticationService;
        _userRepository = userRepository;
        _unitOfWork = unitOfWork;
        _applicationUserRoleRepository = applicationUserRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _userPermissionCacheService = userPermissionCacheService;
        _refreshTokenRepository = refreshTokenRepository;
        _jwtSettings = jwtSettings.Value;
        _logger = logger;
    }

    public async Task<AuthTokenResponse> Handle(LoginCommand command, CancellationToken cancellationToken)
    {
        // 1. Tìm user theo username
        var user = await _userManager.FindByNameAsync(command.UserName);
        if (user == null || user.IsDeleted)
            throw new UnauthorizedException("Tên đăng nhập hoặc mật khẩu không đúng.");

        // 2. Kiểm tra mật khẩu bằng Identity (có tính lockout)
        if (!await _userManager.CheckPasswordAsync(user, command.Password))
        {
            _logger.LogWarning("Đăng nhập thất bại (sai mật khẩu) | UserName={UserName}", command.UserName);
            throw new UnauthorizedException("Tên đăng nhập hoặc mật khẩu không đúng.");
        }

        // 3. Kiểm tra tài khoản có bị khóa không
        if (await _userManager.IsLockedOutAsync(user))
            throw new UnauthorizedException("Tài khoản tạm thời bị khóa do đăng nhập sai nhiều lần.");

        // 4. Phát hành JWT nội bộ
        var token = await _tokenService.CreateTokenAsync(user, cancellationToken);

        // 4.1 Sinh + lưu refresh token (bảng RefreshToken)
        var refreshTokenValue = RefreshTokenHelper.Generate();
        await _refreshTokenRepository.InsertAsync(new RefreshToken
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            TokenHash = RefreshTokenHelper.Hash(refreshTokenValue),
            ExpiresAtUtc = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpirationDays),
            CreatedOnUtc = DateTime.UtcNow
        }, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // 5. Load permissions từ DB rồi cache vào Redis
        var permissions = await LoadUserPermissionsFromDbAsync(user.Id, cancellationToken);

        // 6. Trả về token + thông tin người dùng
        return new AuthTokenResponse
        {
            AccessToken = token.AccessToken,
            RefreshToken = refreshTokenValue,
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
        var roles = await _applicationUserRoleRepository.GetRolesByUserIdAsync(userId, cancellationToken);
        var permissions = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var role in roles)
        {
            var rolePermissions = await _rolePermissionRepository.GetPermissionsByRoleIdAsync(role.Id, cancellationToken);
            foreach (var permission in rolePermissions)
            {
                if (!string.IsNullOrWhiteSpace(permission.Name))
                {
                    permissions.Add(permission.Name);
                }
            }
        }

        return permissions.ToArray();
    }
}
