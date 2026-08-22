namespace SystemService.Application.Models.Roles;

public record RoleModel : BaseEntityModel<Guid>
{
    public string Name { get; set; }
    public string Description { get; set; }
    public List<Guid> Permissions { get; set; } = [];
    /// <summary>
    /// permission: Quyền(Permission) -- group: Nhóm Quyền(Roles)
    /// </summary>
    public string RoleType { get; set; }
}
