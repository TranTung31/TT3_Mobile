using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Infrastructure.Persistence.Configurations.DanhMuc;

public class TieuChuanQuyChuanKyThuatChungConfiguration : IEntityTypeConfiguration<TieuChuanQuyChuanKyThuatChung>
{
    public void Configure(EntityTypeBuilder<TieuChuanQuyChuanKyThuatChung> builder)
    {
        builder.ToTable("TieuChuanQuyChuanKyThuatChungs");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.MaTieuChuanQuyChuan).HasMaxLength(100);
        builder.Property(e => e.TenTieuChuanQuyChuan).HasMaxLength(1000);
        builder.Property(e => e.LoaiTieuChuanQuyChuan).HasMaxLength(1000);
        builder.Property(e => e.GhiChu).HasMaxLength(1000);

        // Quan hệ ngược (Product -> ProductCertification -> TieuChuanQuyChuanKyThuatChung)
        // đã được khai báo trong ProductCertificationConfiguration.
    }
}
