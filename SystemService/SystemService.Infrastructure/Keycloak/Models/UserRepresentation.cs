using System.Text.Json.Serialization;

namespace SystemService.Infrastructure.Keycloak.Models;

public class UserRepresentation
{
    [JsonPropertyName("id")]
    public string Id { get; set; }
    [JsonPropertyName("username")]
    public string Username { get; set; }
    [JsonPropertyName("email")]
    public string Email { get; set; }
    [JsonPropertyName("firstName")]
    public string FirstName { get; set; }
    [JsonPropertyName("lastName")]
    public string LastName { get; set; }
    //[JsonPropertyName("fullName")]
    //public string FullName { get; set; }
    [JsonPropertyName("enabled")]
    public bool Enabled { get; set; } = true;
    [JsonPropertyName("credentials")]
    public List<CredentialRepresentation> Credentials { get; set; }
}
