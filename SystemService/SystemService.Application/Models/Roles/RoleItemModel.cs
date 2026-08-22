namespace SystemService.Application.Models.Roles;

public record RoleItemModel : BaseEntityModel<Guid>
{
    public string Name { get; set; }
    public string Description { get; set; }
}
