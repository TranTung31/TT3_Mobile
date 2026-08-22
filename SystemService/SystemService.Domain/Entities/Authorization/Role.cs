using Microsoft.AspNetCore.Identity;

namespace SystemService.Domain.Entities.Authorization;

/// <summary>
/// Bảng Role (IdentityRole) mở rộng thêm các trường Description, IsActive, CreatedOnUtc, UpdatedOnUtc
/// </summary>
public partial class Role : IdentityRole<Guid>
{
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;

    // Bổ sung lại nếu cần audit (xem Bước 2)
    public DateTime CreatedOnUtc { get; set; }
    public DateTime? UpdatedOnUtc { get; set; }

    public virtual ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
    public virtual ICollection<IdentityUserRole<Guid>> UserRoles { get; set; } = new List<IdentityUserRole<Guid>>();
}
