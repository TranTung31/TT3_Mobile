namespace SystemService.Application.Models.Keycloak;

public class KeycloakRoleCreateRequest
{
    public string Name { get; set; }
    public string Description { get; set; }
    public Dictionary<string, List<string>> Attributes { get; set; }
}
