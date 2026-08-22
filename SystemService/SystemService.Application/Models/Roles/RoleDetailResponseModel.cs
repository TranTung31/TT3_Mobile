namespace SystemService.Application.Models.Roles;

public record RoleDetailResponseModel : BaseEntityModel<Guid>
{
    public string Name { get; set; }
    public string Description { get; set; }
    public List<PermissionNode> Permissions { get; set; } = [];
}
