namespace SystemService.Application.Models.Catalog.DmDonVi;

public class DmDonViTreeModel
{
    public Guid Id { get; set; }

    /// <summary>
    /// Mã đơn vị
    /// </summary>
    public string MaDonVi { get; set; }

    /// <summary>
    /// Tên đơn vị
    /// </summary>
    public string TenDonVi { get; set; }

    /// <summary>
    /// Mã địa bàn
    /// </summary>
    public string MaDiaBan { get; set; }

    /// <summary>
    /// Địa chỉ
    /// </summary>
    public string DiaChi { get; set; }

    /// <summary>
    /// Điện thoại
    /// </summary>
    public string DienThoai { get; set; }

    public int CapDuToan { get; set; }

    public bool LaDonViChiTiet { get; set; }

    /// <summary>
    /// Đơn vị cha id
    /// </summary>
    public Guid? DonViChaId { get; set; }

    /// <summary>
    /// Trạng thái
    /// </summary>
    public int TrangThai { get; set; }

    public bool? DuocPhepTaoNoiDungThuChi { set; get; }

    public virtual List<DmDonViTreeModel> Children { get; set; } = [];
}
