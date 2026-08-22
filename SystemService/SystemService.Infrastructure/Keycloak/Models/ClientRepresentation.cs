using System.Text.Json.Serialization;

namespace SystemService.Infrastructure.Keycloak.Models;

public class ClientRepresentation
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    [JsonPropertyName("clientId")]
    public string ClientId { get; set; }

    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonPropertyName("enabled")]
    public bool Enabled { get; set; }
}