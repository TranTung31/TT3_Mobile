using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Infrastructure.Persistence.Configurations.DanhMuc;

public class NuocXuatXuConfiguration : IEntityTypeConfiguration<NuocXuatXu>
{
    public void Configure(EntityTypeBuilder<NuocXuatXu> builder)
    {
        builder.ToTable("NuocXuatXus");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.MaNuocXuatXu).HasMaxLength(100);
        builder.Property(e => e.TenNuocXuatXu).HasMaxLength(1000);
        builder.Property(e => e.GhiChu).HasMaxLength(1000);
    }
}
