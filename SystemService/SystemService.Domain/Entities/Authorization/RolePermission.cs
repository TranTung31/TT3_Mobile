namespace SystemService.Domain.Entities.Authorization;

/// <summary>
/// Mapping giữa Role và Permission (Composite Role trên Keycloak).
/// </summary>
public partial class RolePermission : BaseEntity<Guid>
{
    /// <summary>
    /// ID của Role
    /// </summary>
    public Guid RoleId { get; set; }

    /// <summary>
    /// ID của Permission
    /// </summary>
    public Guid PermissionId { get; set; }

    /// <summary>
    /// Role liên quan
    /// </summary>
    public virtual Role Role { get; set; }

    /// <summary>
    /// Permission liên quan
    /// </summary>
    public virtual Permission Permission { get; set; }
}
