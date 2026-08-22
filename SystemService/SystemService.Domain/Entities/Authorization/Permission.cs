namespace SystemService.Domain.Entities.Authorization;

/// <summary>
/// Đại diện cho một quyền (Permission) trong hệ thống.
/// Tương ứng với Client Role trên Keycloak.
/// Nguồn: TcdtPermissions (định nghĩa trong code).
/// </summary>
public partial class Permission : BaseEntity<Guid>
{
    /// <summary>
    /// Tên permission (unique) - ví dụ: "TcdtPermissions.DmDonVi.View"
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// Mô tả tiếng Việt - ví dụ: "Xem"
    /// </summary>
    public string Description { get; set; }

    /// <summary>
    /// Đường dẫn nhóm - ví dụ: "Danh mục đơn vị" (dùng để hiển thị tree)
    /// </summary>
    public string GroupPath { get; set; }

    /// <summary>
    /// Kích hoạt
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// Danh sách các role chứa permission này
    /// </summary>
    public virtual ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
}
