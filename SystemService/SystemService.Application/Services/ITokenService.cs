using SystemService.Domain.Entities.Users;

namespace SystemService.Application.Services;

public record TokenResult(string AccessToken, int ExpiresIn);

public interface ITokenService
{
    Task<TokenResult> CreateTokenAsync(ApplicationUser user, CancellationToken cancellationToken = default);
}
