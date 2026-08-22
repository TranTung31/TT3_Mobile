using System.ComponentModel.DataAnnotations.Schema;
using SystemService.Domain.Entities.Enums;

namespace SystemService.Domain.Entities.Common;

/// <summary>
/// Quản lý menu
/// </summary>
public partial class ApplicationMenu : BaseEntity<Guid>
{
    /// <summary>
    /// Tên menu
    /// </summary>
    public required string Name { get; set; }

    /// <summary>
    /// Đường dẫn
    /// </summary>
    public string Path { get; set; }

    /// <summary>
    /// Icon menu
    /// </summary>
    public string Icon { get; set; }

    /// <summary>
    /// Thứ tự hiển thị
    /// </summary>
    public int Order { get; set; }

    /// <summary>
    /// Kích hoạt hiển thị
    /// </summary>
    public bool IsActive { get; set; }

    /// <summary>
    /// Id menu cha
    /// </summary>
    public Guid? ParentId { get; set; }

    /// <summary>
    /// Menu hệ thống type
    /// </summary>
    public MenuHeThongType? Type { get; set; }

    /// <summary>
    /// Dùng để phân biệt menu ngang
    /// </summary>
    public bool? isHorizontal { get; set; }

    /// <summary>
    /// Thông tin menu cha
    /// </summary>
    public virtual ApplicationMenu? Parent { get; set; }

    /// <summary>
    /// Danh sách menu con
    /// </summary>
    public virtual ICollection<ApplicationMenu> Children { get; set; } = new List<ApplicationMenu>();
    public virtual ICollection<MenuPermission> RequiredPermissions { get; set; } = new List<MenuPermission>();
}
