using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Products;

namespace SystemService.Infrastructure.Persistence.Configurations.Products;

public class ProductChannelDistributionConfiguration : IEntityTypeConfiguration<ProductChannelDistribution>
{
    public void Configure(EntityTypeBuilder<ProductChannelDistribution> builder)
    {
        builder.ToTable("ProductChannelDistributions");

        builder.HasKey(e => e.Id);

        // Một sản phẩm có nhiều kênh phân phối
        builder.HasOne(e => e.Product)
            .WithMany(p => p.ProductDistributions)
            .HasForeignKey(e => e.ProductId)
            .OnDelete(DeleteBehavior.Cascade);

        // Một kênh phân phối có nhiều sản phẩm
        builder.HasOne(e => e.KenhPhanPhoiDoanhNghiep)
            .WithMany(k => k.ProductDistributions)
            .HasForeignKey(e => e.KenhPhanPhoiDoanhNghiepId)
            .OnDelete(DeleteBehavior.Restrict);

        // Một sản phẩm không được trùng kênh phân phối
        builder.HasIndex(e => new { e.ProductId, e.KenhPhanPhoiDoanhNghiepId }).IsUnique();
    }
}
