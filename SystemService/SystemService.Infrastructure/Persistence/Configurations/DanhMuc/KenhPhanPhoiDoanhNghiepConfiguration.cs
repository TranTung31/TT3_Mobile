using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Infrastructure.Persistence.Configurations.DanhMuc;

public class KenhPhanPhoiDoanhNghiepConfiguration : IEntityTypeConfiguration<KenhPhanPhoiDoanhNghiep>
{
    public void Configure(EntityTypeBuilder<KenhPhanPhoiDoanhNghiep> builder)
    {
        builder.ToTable("KenhPhanPhoiDoanhNghieps");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.MaPhanPhoi).HasMaxLength(50);
        builder.Property(e => e.TenKenhPhanPhoi).HasMaxLength(500);
        builder.Property(e => e.GhiChu).HasMaxLength(1000);

        // Quan hệ ngược (Product -> ProductChannelDistribution -> KenhPhanPhoiDoanhNghiep)
        // đã được khai báo trong ProductChannelDistributionConfiguration.
    }
}
