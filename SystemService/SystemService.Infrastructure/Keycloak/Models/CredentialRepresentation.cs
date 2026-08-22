using System.Text.Json.Serialization;

namespace SystemService.Infrastructure.Keycloak.Models;

public class CredentialRepresentation
{
    [JsonPropertyName("type")]
    public string Type { get; set; } = "password";
    [JsonPropertyName("value")]
    public string Value { get; set; }
    [JsonPropertyName("temporary")]
    public bool Temporary { get; set; } = false;
}
