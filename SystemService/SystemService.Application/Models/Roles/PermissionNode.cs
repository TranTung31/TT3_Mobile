namespace SystemService.Application.Models.Roles;

public record PermissionNode : BaseEntityModel<Guid>
{
    public string Permission { get; set; }
    public string Name { get; set; }
}