using System.Text.Json.Serialization;

namespace SystemService.Infrastructure.Keycloak.Models;

public class AccessTokenResponse
{
    [JsonPropertyName("access_token")]
    public string AccessToken { get; set; }
}
