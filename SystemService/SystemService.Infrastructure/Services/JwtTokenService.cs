using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Shared.Security;
using Shared.Security.Constants;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using SystemService.Application.Services;
using SystemService.Domain.Entities.Users;

namespace SystemService.Infrastructure.Services;

public class JwtTokenService : ITokenService
{
    private readonly JwtSettings _jwtSettings;
    private readonly UserManager<ApplicationUser> _userManager;

    public JwtTokenService(IOptions<JwtSettings> jwtSettings, UserManager<ApplicationUser> userManager)
    {
        _jwtSettings = jwtSettings.Value;
        _userManager = userManager;
    }

    public async Task<TokenResult> CreateTokenAsync(ApplicationUser user, CancellationToken cancellationToken = default)
    {
        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.SecretKey));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        var roles = await _userManager.GetRolesAsync(user);

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new(JwtRegisteredClaimNames.UniqueName, user.UserName ?? string.Empty),
            new(CustomClaimTypes.UserId, user.Id.ToString()),
            new(CustomClaimTypes.UserName, user.UserName ?? string.Empty),
            new(CustomClaimTypes.FullName, user.FullName ?? string.Empty),
            new(CustomClaimTypes.IsSuperAdmin, user.IsSuperAdmin ? "true" : "false"),
        };
        if (user.DonViId.HasValue)
            claims.Add(new(CustomClaimTypes.UnitId, user.DonViId.Value.ToString()));
        claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

        // Đọc từ cấu hình thay vì hardcode 60 phút
        var lifetimeMinutes = _jwtSettings.ExpirationInMinutes > 0 ? _jwtSettings.ExpirationInMinutes : 60;

        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: DateTime.UtcNow.AddMinutes(lifetimeMinutes),
            signingCredentials: credentials);

        return new TokenResult(
            new JwtSecurityTokenHandler().WriteToken(token),
            ExpiresIn: lifetimeMinutes * 60);
    }
}
