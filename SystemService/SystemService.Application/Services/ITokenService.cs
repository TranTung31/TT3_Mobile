using SystemService.Domain.Entities.Users;

namespace SystemService.Application.Services;

public record TokenResult(string AccessToken, int ExpiresIn);

public interface ITokenService
{
    /// <summary>
    /// Tạo access token. Danh sách permission (nếu có) sẽ được nhúng vào claim
    /// để PermissionAuthorizationHandler check quyền trực tiếp từ token.
    /// </summary>
    Task<TokenResult> CreateTokenAsync(ApplicationUser user, IEnumerable<string> permissions = null, CancellationToken cancellationToken = default);
}
