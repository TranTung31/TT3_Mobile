namespace SystemService.Domain.Entities.Common;

public class MenuPermission : BaseEntity<Guid>
{
    /// <summary>
    /// Gets or sets the menu identifier
    /// </summary>
    public Guid ApplicationMenuId { get; set; }

    /// <summary>
    /// Gets or sets the name of the required permission
    /// </summary>
    public required string PermissionName { get; set; }

    /// <summary>
    /// Gets or sets the navigation property for the menu
    /// </summary>
    public virtual ApplicationMenu ApplicationMenu { get; set; }
}
