using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Infrastructure.Persistence.Configurations.DanhMuc;

public class QuyCachDongGoiConfiguration : IEntityTypeConfiguration<QuyCachDongGoi>
{
    public void Configure(EntityTypeBuilder<QuyCachDongGoi> builder)
    {
        builder.ToTable("QuyCachDongGois");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.MaQuyCach).HasMaxLength(100);
        builder.Property(e => e.TenQuyCach).HasMaxLength(1000);
        builder.Property(e => e.Description).HasMaxLength(1000);
    }
}
