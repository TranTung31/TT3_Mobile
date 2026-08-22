using Microsoft.Extensions.Options;
using System.Net.Http.Json;
using System.Text.Json;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Auth;
using SystemService.Application.Services;
using SystemService.Infrastructure.Settings;

namespace SystemService.Infrastructure.Services;

public class KeycloakAuthenticationService : IAuthenticationService
{
    //private readonly IHttpClientFactory _httpClientFactory;
    private readonly HttpClient _httpClient;
    private readonly KeycloakSettings _keycloakSettings;

    public KeycloakAuthenticationService(HttpClient httpClient, IOptions<KeycloakSettings> keycloakOptions)
    {
        _httpClient = httpClient;
        _keycloakSettings = keycloakOptions.Value;
    }

    public async Task<KeycloakTokenResponse> ExchangeCodeForTokenAsync(string authorizationCode, string redirectUri, CancellationToken cancellationToken = default)
    {
        //var httpClient = _httpClientFactory.CreateClient();
        var content = new FormUrlEncodedContent(
        [
            new KeyValuePair<string, string>("grant_type", "authorization_code"),
            new KeyValuePair<string, string>("code", authorizationCode),
            new KeyValuePair<string, string>("redirect_uri", redirectUri),
            new KeyValuePair<string, string>("client_id", _keycloakSettings.ClientId),
            new KeyValuePair<string, string>("client_secret", _keycloakSettings.ClientSecret)
        ]);
        var response = await _httpClient.PostAsync(
            $"{_keycloakSettings.AuthServerUrl}/realms/{_keycloakSettings.Realm}/protocol/openid-connect/token",
            content,
            cancellationToken);
        if (!response.IsSuccessStatusCode)
        {
            var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
            throw new BadRequestException($"Lỗi khi trao đổi token: {errorContent}");
        }
        var tokenResponse = await response.Content.ReadFromJsonAsync<KeycloakTokenResponse>(cancellationToken: cancellationToken);
        return tokenResponse ?? throw new BadRequestException("Không nhận được phản hồi token hợp lệ.");
    }

    public async Task<KeycloakTokenResponse> RefreshTokenAsync(string refreshToken, CancellationToken cancellationToken = default)
    {
        //var httpClient = _httpClientFactory.CreateClient();

        var content = new FormUrlEncodedContent(
        [
            new KeyValuePair<string, string>("grant_type", "refresh_token"),
            new KeyValuePair<string, string>("client_id", _keycloakSettings.ClientId),
            new KeyValuePair<string, string>("client_secret", _keycloakSettings.ClientSecret),
            new KeyValuePair<string, string>("refresh_token", refreshToken)
        ]);
        var response = await _httpClient.PostAsync(
            $"{_keycloakSettings.AuthServerUrl}/realms/{_keycloakSettings.Realm}/protocol/openid-connect/token",
            content,
            cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
            throw new BadRequestException($"Lỗi khi trao đổi token: {errorContent}");
        }

        var tokenResponse = await response.Content.ReadFromJsonAsync<KeycloakTokenResponse>(cancellationToken: cancellationToken);
        return tokenResponse ?? throw new BadRequestException("Lỗi khi làm mới token.");
    }

    public async Task<KeycloakTokenResponse> LoginWithUserPasswordAsync(string userName, string password, CancellationToken cancellationToken = default)
    {
        var tokenEndpoint = $"{_keycloakSettings.AuthServerUrl}/realms/{_keycloakSettings.Realm}/protocol/openid-connect/token";
        var form = new Dictionary<string, string>
        {
            ["grant_type"] = "password",
            ["client_id"] = _keycloakSettings.ClientId,
            ["client_secret"] = _keycloakSettings.ClientSecret,
            ["username"] = userName,
            ["password"] = password
        };

        var response = await _httpClient.PostAsync(tokenEndpoint, new FormUrlEncodedContent(form), cancellationToken);
        response.EnsureSuccessStatusCode();

        var json = await response.Content.ReadAsStringAsync(cancellationToken);
        var tokenResponse = JsonSerializer.Deserialize<KeycloakTokenResponse>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        return tokenResponse ?? throw new BadRequestException("Không nhận được phản hồi token hợp lệ.");
    }
}
