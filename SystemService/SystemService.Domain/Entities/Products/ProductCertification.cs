using SystemService.Domain.Entities.Catalog;
using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Domain.Entities.Products;

public class ProductCertification : BaseEntity<Guid>
{
    public string Tep { get; set; }

    public Guid ChungNhanId { get; set; }
    public virtual TieuChuanQuyChuanKyThuatChung TieuChuanQuyChuanKyThuatChung { get; set; }

    public Guid ProductId { get; set; }
    public virtual Product Product { get; set; }

    public Guid DonViId { get; set; }
    public virtual DmDonVi DmDonVi { get; set; }
}
