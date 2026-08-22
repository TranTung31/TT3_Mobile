namespace SystemService.Application.Models.Keycloak;

public class KeycloakRoleInfo
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }

    public Dictionary<string, List<string>> Attributes { get; set; }
}
