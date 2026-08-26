using SystemService.Domain.Entities.Products;

namespace SystemService.Domain.Entities.DanhMuc;

public class KenhPhanPhoiDoanhNghiep : BaseEntity<Guid>, ISoftDeletedEntity
{
    public string MaPhanPhoi { get; set; }
    public string TenKenhPhanPhoi { get; set; }
    public string GhiChu { get; set; }

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }

    public virtual ICollection<ProductChannelDistribution> ProductDistributions { get; set; } = [];
}
