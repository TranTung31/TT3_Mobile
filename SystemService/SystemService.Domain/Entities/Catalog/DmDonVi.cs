using System.ComponentModel.DataAnnotations;
using SystemService.Domain.Entities.Enums;

namespace SystemService.Domain.Entities.Catalog;

public partial class DmDonVi: BaseEntity<Guid>, ISoftDeletedEntity
{
    /// <summary>
    /// Mã đơn vị
    /// </summary>
    public required string MaDonVi { get; set; }

    /// <summary>
    /// Tên đơn vị
    /// </summary>
    public required string TenDonVi { get; set; }

    /// <summary>
    /// Mã địa bàn
    /// </summary>
    public string MaDiaBan { get; set; }

    /// <summary>
    /// Địa chỉ
    /// </summary>
    public string DiaChi { get; set; }

    /// <summary>
    /// Điện thoại
    /// </summary>
    public string DienThoai { get; set; }

    /// <summary>
    /// Trạng thái
    /// </summary>
    public int TrangThai { get; set; }

    public int CapDuToan { get; set; }

    /// <summary>
    /// Xác định cấp của danh mục
    /// </summary>
    public int? CapDonVi { get; set; }

    /// <summary>
    /// Xác định mã phân cấp của danh mục, dùng để sắp xếp danh mục theo thứ tự phân cấp
    /// </summary>
    [StringLength(255)]
    public string MaPhanCap { get; set; }

    public bool LaDonViChiTiet { get; set; }

    public bool LaCucLoaiHai { set; get; } = false;

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }

    public Guid? DonViChaId { get; set; }
    public virtual DmDonVi? DonViCha { get; set; }
    public virtual ICollection<DmDonVi> DonViCon { get; set; } = [];

    public string Email { get; set; }
    public string Fax { get; set; }
    public string MaSoThue { get; set; }
}
