namespace Shared.Contracts.DanhMuc;

public class DmDonViGrpcModel
{
    public Guid Id { get; set; }
    public string MaDonVi { get; set; }
    public string TenDonVi { get; set; }
    public int CapDuToan { get; set; }
    public bool LaDonViChiTiet { get; set; }
    public Guid? DonViChaId { get; set; }
}
