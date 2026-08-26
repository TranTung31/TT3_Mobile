using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Products;

namespace SystemService.Infrastructure.Persistence.Configurations.Products;

public class ProductCertificationConfiguration : IEntityTypeConfiguration<ProductCertification>
{
    public void Configure(EntityTypeBuilder<ProductCertification> builder)
    {
        builder.ToTable("ProductCertifications");

        builder.HasKey(e => e.Id);

        // Một sản phẩm có nhiều chứng chỉ
        builder.HasOne(e => e.Product)
            .WithMany(p => p.ProductCertifications)
            .HasForeignKey(e => e.ProductId)
            .OnDelete(DeleteBehavior.Cascade);

        // Một tiêu chuẩn/quy chuẩn được cấp cho nhiều sản phẩm
        builder.HasOne(e => e.TieuChuanQuyChuanKyThuatChung)
            .WithMany(t => t.ProductCertifications)
            .HasForeignKey(e => e.ChungNhanId)
            .OnDelete(DeleteBehavior.Restrict);

        // Đơn vị cấp chứng chỉ
        builder.HasOne(e => e.DmDonVi)
            .WithMany()
            .HasForeignKey(e => e.DonViId)
            .OnDelete(DeleteBehavior.Restrict);

        // Không trùng lặp chứng chỉ cho cùng (sản phẩm, tiêu chuẩn, đơn vị)
        builder.HasIndex(e => new { e.ProductId, e.ChungNhanId, e.DonViId }).IsUnique();
    }
}
