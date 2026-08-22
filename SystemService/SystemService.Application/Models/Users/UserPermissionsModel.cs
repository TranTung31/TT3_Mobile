namespace SystemService.Application.Models.Users;

public record UserPermissionsModel
{
    public Guid UserId { get; set; }
    public List<string> Roles { get; set; } = new();
    public List<string> Permissions { get; set; } = new();
}