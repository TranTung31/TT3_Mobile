namespace SystemService.Application.Models.Keycloak;

public class KeycloakUserInfo
{
    public string Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string FullName { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public bool IsEnabled { get; set; }
}
