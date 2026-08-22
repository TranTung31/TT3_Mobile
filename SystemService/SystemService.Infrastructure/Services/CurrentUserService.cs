using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using Shared.Contracts.Authentication;
using Shared.Security.Constants;
using SystemService.Application.Services;

namespace SystemService.Infrastructure.Services;

/// <summary>
/// Lấy thông tin user đang đăng nhập từ claims của JWT (phát hành bởi JwtTokenService).
/// Không truy vấn DB — dữ liệu nằm sẵn trong access token.
/// </summary>
public class CurrentUserService : ICurrentUserService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CurrentUserService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public CurrentUser? User
    {
        get
        {
            var principal = _httpContextAccessor.HttpContext?.User;
            if (principal == null || principal.Identity?.IsAuthenticated != true)
                return null;

            var userId = GetClaim(principal, CustomClaimTypes.UserId)
                         ?? GetClaim(principal, ClaimTypes.NameIdentifier)
                         ?? GetClaim(principal, JwtRegisteredClaimNames.Sub);
            if (!Guid.TryParse(userId, out var id))
                return null;

            return new CurrentUser
            {
                Id = id,
                UserName = GetClaim(principal, CustomClaimTypes.UserName)
                           ?? GetClaim(principal, JwtRegisteredClaimNames.UniqueName)
                           ?? string.Empty,
                FullName = GetClaim(principal, CustomClaimTypes.FullName) ?? string.Empty,
                DonViId = ParseGuid(GetClaim(principal, CustomClaimTypes.UnitId)),
                IsSuperAdmin = bool.TryParse(GetClaim(principal, CustomClaimTypes.IsSuperAdmin), out var isSuperAdmin) && isSuperAdmin,
                LinhVucQuanLy = 0
            };
        }
    }

    public Guid? GetUserId() => User?.Id;

    public Guid? GetDonViId() => User?.DonViId;

    public bool IsSuperAdmin() => User?.IsSuperAdmin ?? false;

    private static string? GetClaim(ClaimsPrincipal principal, string type)
        => principal.FindFirst(type)?.Value;

    private static Guid? ParseGuid(string? value)
        => Guid.TryParse(value, out var guid) ? guid : null;
}
