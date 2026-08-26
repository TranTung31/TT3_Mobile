using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Infrastructure.Persistence.Configurations.DanhMuc;

public class NhomSanPhamHangHoaConfiguration : IEntityTypeConfiguration<NhomSanPhamHangHoa>
{
    public void Configure(EntityTypeBuilder<NhomSanPhamHangHoa> builder)
    {
        builder.ToTable("NhomSanPhamHangHoas");

        builder.HasKey(e => e.Id);

        builder.Property(e => e.MaNhomSanPhamHangHoa).HasMaxLength(100);
        builder.Property(e => e.TenNhomSanPhamHangHoa).HasMaxLength(1000);
        builder.Property(e => e.Mota).HasMaxLength(1000);
        builder.Property(e => e.LoaiNhom).HasMaxLength(1000);

        // Quan hệ tự tham chiếu cha - con (cây danh mục).
        // Restrict để tránh lỗi "multiple cascade paths" của SQL Server khi cây tự tham chiếu.
        builder.HasOne(e => e.NhomSanPhamHangHoaCha)
            .WithMany()
            .HasForeignKey(e => e.ParentId)
            .OnDelete(DeleteBehavior.Restrict);

        // Index theo cha để truy vấn cây nhanh hơn
        builder.HasIndex(e => e.ParentId);
    }
}
