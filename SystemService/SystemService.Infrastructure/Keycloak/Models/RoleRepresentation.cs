using System.Text.Json.Serialization;

namespace SystemService.Infrastructure.Keycloak.Models;

public class RoleRepresentation
{
    [JsonPropertyName("id")]
    public string Id { get; set; }

    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonPropertyName("description")]
    public string Description { get; set; }

    [JsonPropertyName("clientRole")]
    public bool ClientRole { get; set; }

    [JsonPropertyName("attributes")]
    public Dictionary<string, List<string>> Attributes { get; set; }
}
