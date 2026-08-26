using SystemService.Domain.Entities.DanhMuc;

namespace SystemService.Domain.Entities.Products;

/// <summary>
/// Bảng sản phẩm, hàng hóa
/// </summary>
public class Product : BaseEntity<Guid>, ISoftDeletedEntity
{
    public string TenSanPham { get; set; }
    public string MaGTIN { get; set; }
    public string MoTa { get; set; }
    public string ThuongHieu { get; set; }
    public string NhaSanXuat { get; set; }
    public string DiaChiNhaSanXuat { get; set; }
    public string ThuongNhanNhapKhau { get; set; }
    public string DiaChiThuongNhanNhapKhau { get; set; }
    public double GiaBanNiemYet { get; set; }
    public DateTime? HanSuDung { get; set; }
    public string TrongLuong { get; set; }
    public string KichThuoc { get; set; }
    public string MoTaChatLieuMauSac { get; set; }
    public string DoiTacNhapKhau { get; set; }
    public string DiaChiDoiTacNhapKhau { get; set; }
    public string LinkWebsiteSp { get; set; }
    public string LinkSanTmdt { get; set; }
    public string DacTinhCongDung { get; set; }
    public string NguyenLieuVatLieuChinh { get; set; }
    public string DVBHThoiHanBaoHanh { get; set; }
    public string DVBHThongTinLienHe { get; set; }
    public string DVBHHauMai { get; set; }
    public string CanhBaoGiaMao { get; set; }

    /// <summary>
    /// Loại sản phẩm
    /// </summary>
    public Guid LoaiSanPhamId { get; set; }
    public virtual NhomSanPhamHangHoa NhomSanPhamHangHoa { get; set; }

    /// <summary>
    /// Đóng gói
    /// </summary>
    public Guid DongGoiId { get; set; }
    public virtual QuyCachDongGoi QuyCachDongGoi { get; set; }

    /// <summary>
    /// Xuất xứ
    /// </summary>
    public Guid XuatXuId { get; set; }
    public virtual NuocXuatXu XuatXu { get; set; }

    /// <summary>
    /// Thị trường nhập khẩu
    /// </summary>
    public Guid ThiTruongNhapKhauId { get; set; }
    public virtual NuocXuatXu ThiTruongNhapKhau { get; set; }

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }

    /// <summary>
    /// Kênh phân phối của doanh nghiệp
    /// </summary>
    public virtual ICollection<ProductChannelDistribution> ProductDistributions { get; set; } = [];

    /// <summary>
    /// Chứng chỉ đạt được
    /// </summary>
    public virtual ICollection<ProductCertification> ProductCertifications { get; set; } = [];
}
