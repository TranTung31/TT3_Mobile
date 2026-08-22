namespace SystemService.Application.Models.Roles;

public record PermissionGroup
{
    public string Name { get; set; }
    public List<PermissionNode> Permissions { get; set; } = new();
    public List<PermissionGroup> SubGroups { get; set; } = new();
}
