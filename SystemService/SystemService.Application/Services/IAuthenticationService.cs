using SystemService.Application.Models.Auth;

namespace SystemService.Application.Services;

public interface IAuthenticationService
{
    Task<KeycloakTokenResponse> ExchangeCodeForTokenAsync(string authorizationCode, string redirectUri, CancellationToken cancellationToken = default);
    Task<KeycloakTokenResponse> LoginWithUserPasswordAsync(string userName, string password, CancellationToken cancellationToken = default);
    Task<KeycloakTokenResponse> RefreshTokenAsync(string refreshToken, CancellationToken cancellationToken = default);
}
