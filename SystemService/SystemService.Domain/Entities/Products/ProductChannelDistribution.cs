using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Domain.Entities.Products;

public class ProductChannelDistribution : BaseEntity<Guid>
{
    public Guid KenhPhanPhoiDoanhNghiepId { get; set; }
    public virtual KenhPhanPhoiDoanhNghiep KenhPhanPhoiDoanhNghiep { get; set; }
    public Guid ProductId { get; set; }
    public virtual Product Product { get; set; }
}
