namespace SystemService.Infrastructure.Settings;

public class KeycloakSettings
{
    public string AuthServerUrl { get; set; }
    public string Realm { get; set; }
    public string ClientId { get; set; }
    public string ClientSecret { get; set; }
    public string AdminClientId { get; set; }
    public string AdminClientSecret { get; set; }
    public string DefaultImportedUserPassword { get; set; } = "Ab@123456";
}
