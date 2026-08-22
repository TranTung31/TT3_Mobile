namespace SystemService.Application.Models.Keycloak;

public class KeycloakUserUpdateRequest
{
    public string Email { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public bool Enabled { get; set; }
}