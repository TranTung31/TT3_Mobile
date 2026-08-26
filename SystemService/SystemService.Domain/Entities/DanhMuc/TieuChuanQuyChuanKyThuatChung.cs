using SystemService.Domain.Entities.Products;

namespace SystemService.Domain.Entities.DanhMuc;

public class TieuChuanQuyChuanKyThuatChung : BaseEntity<Guid>, ISoftDeletedEntity
{
    public string MaTieuChuanQuyChuan { get; set; }
    public string TenTieuChuanQuyChuan { get; set; }
    public string LoaiTieuChuanQuyChuan { get; set; }
    public string GhiChu { get; set; }

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }

    public virtual ICollection<ProductCertification> ProductCertifications { get; set; } = [];
}
