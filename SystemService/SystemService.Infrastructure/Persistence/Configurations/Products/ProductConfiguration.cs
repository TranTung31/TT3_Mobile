using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Products;

namespace SystemService.Infrastructure.Persistence.Configurations.Products;

public class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> builder)
    {
        builder.ToTable("Products");

        builder.HasKey(e => e.Id);

        //builder.Property(e => e.TenSanPham).HasMaxLength(500);
        //builder.Property(e => e.MaGTIN).HasMaxLength(50);
        //builder.Property(e => e.MoTa).HasMaxLength(2000);
        //builder.Property(e => e.ThuongHieu).HasMaxLength(500);
        //builder.Property(e => e.NhaSanXuat).HasMaxLength(500);
        //builder.Property(e => e.DiaChiNhaSanXuat).HasMaxLength(1000);
        //builder.Property(e => e.ThuongNhanNhapKhau).HasMaxLength(500);
        //builder.Property(e => e.DiaChiThuongNhanNhapKhau).HasMaxLength(1000);
        //builder.Property(e => e.TrongLuong).HasMaxLength(100);
        //builder.Property(e => e.KichThuoc).HasMaxLength(100);
        //builder.Property(e => e.MoTaChatLieuMauSac).HasMaxLength(1000);
        //builder.Property(e => e.DoiTacNhapKhau).HasMaxLength(500);
        //builder.Property(e => e.DiaChiDoiTacNhapKhau).HasMaxLength(1000);
        //builder.Property(e => e.LinkWebsiteSp).HasMaxLength(500);
        //builder.Property(e => e.LinkSanTmdt).HasMaxLength(500);
        //builder.Property(e => e.DacTinhCongDung).HasMaxLength(2000);
        //builder.Property(e => e.NguyenLieuVatLieuChinh).HasMaxLength(1000);
        //builder.Property(e => e.DVBHThoiHanBaoHanh).HasMaxLength(500);
        //builder.Property(e => e.DVBHThongTinLienHe).HasMaxLength(500);
        //builder.Property(e => e.DVBHHauMai).HasMaxLength(1000);
        //builder.Property(e => e.CanhBaoGiaMao).HasMaxLength(1000);

        // Index tra cứu theo mã GTIN
        //builder.HasIndex(e => e.MaGTIN);

        // Loại sản phẩm
        builder.HasOne(e => e.NhomSanPhamHangHoa)
            .WithMany()
            .HasForeignKey(e => e.LoaiSanPhamId)
            .OnDelete(DeleteBehavior.Restrict);

        // Đóng gói
        builder.HasOne(e => e.QuyCachDongGoi)
            .WithMany()
            .HasForeignKey(e => e.DongGoiId)
            .OnDelete(DeleteBehavior.Restrict);

        // Xuất xứ
        builder.HasOne(e => e.XuatXu)
            .WithMany()
            .HasForeignKey(e => e.XuatXuId)
            .OnDelete(DeleteBehavior.Restrict);

        // Thị trường nhập khẩu
        builder.HasOne(e => e.ThiTruongNhapKhau)
            .WithMany()
            .HasForeignKey(e => e.ThiTruongNhapKhauId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
