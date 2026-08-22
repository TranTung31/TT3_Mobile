using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Catalog;

namespace SystemService.Infrastructure.Persistence.Configurations;

public class DmDonViConfiguration : IEntityTypeConfiguration<DmDonVi>
{
    public void Configure(EntityTypeBuilder<DmDonVi> builder)
    {
        builder.ToTable("DmDonVi");

        builder.HasKey(a => a.Id);

        builder.Property(a => a.MaDonVi)
            .HasMaxLength(50)
            .IsRequired();

        builder.Property(a => a.TenDonVi)
            .HasMaxLength(500)
            .IsRequired();

        builder.Property(a => a.MaDiaBan)
            .HasMaxLength(50);

        builder.Property(a => a.DiaChi)
            .HasMaxLength(1000);

        builder.Property(a => a.DienThoai)
            .HasMaxLength(20);

        builder.Property(x => x.Email)
            .HasMaxLength(256);

        builder.Property(x => x.Fax)
            .HasMaxLength(256);

        builder.Property(x => x.MaSoThue)
            .HasMaxLength(256);

		builder.HasOne(t => t.DonViCha)
            .WithMany(p => p.DonViCon)
            .HasForeignKey(t => t.DonViChaId)
            .OnDelete(deleteBehavior: DeleteBehavior.Restrict);

        builder.Property(x => x.LaCucLoaiHai)
            .HasDefaultValue(false)
            .IsRequired();
    }
}