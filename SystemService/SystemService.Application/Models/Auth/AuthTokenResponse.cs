namespace SystemService.Application.Models.Auth;

public class AuthTokenResponse
{
    public string AccessToken { get; set; }
    public string RefreshToken { get; set; }
    public int ExpiresIn { get; set; }
    public Guid UserId { get; set; }
    public string UserName { get; set; }
    public string FullName { get; set; }
    public Guid? DonViId { get; set; }
    public bool IsSuperAdmin { get; set; }
    public List<string> Roles { get; set; } = new List<string>();
    public List<string> Permissions { get; set; } = new List<string>();
}
