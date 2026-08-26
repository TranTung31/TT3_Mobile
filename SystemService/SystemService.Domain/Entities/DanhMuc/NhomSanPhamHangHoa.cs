namespace SystemService.Domain.Entities.DanhMuc;

public class NhomSanPhamHangHoa : BaseEntity<Guid>, ISoftDeletedEntity
{
    public string MaNhomSanPhamHangHoa { get; set; }
    public string TenNhomSanPhamHangHoa { get; set; }
    public string Mota { get; set; }
    public string LoaiNhom { get; set; }

    public Guid ParentId { get; set; }
    public virtual NhomSanPhamHangHoa NhomSanPhamHangHoaCha { get; set; }

    public int TrangThai { get; set; }

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }
}
