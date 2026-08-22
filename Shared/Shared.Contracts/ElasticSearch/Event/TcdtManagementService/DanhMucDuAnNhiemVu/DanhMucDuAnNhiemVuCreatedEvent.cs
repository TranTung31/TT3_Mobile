namespace Shared.Contracts.ElasticSearch.Event.TcdtManagementService.DanhMucDuAnNhiemVu;
public class DanhMucDuAnNhiemVuCreatedEvent
{
    public Guid Id { set; get; }
    public Guid DonViId { get; set; }
    public string TenDonVi { get; set; }
    public Guid KyTrungHanId { get; set; }
    public string TenKyTrungHan { get; set; }
    public int LinhVucQuanLyId { get; set; }
    public string LinhVucQuanLy { set; get; }
    public decimal TongNhuCauKHV { get; set; }
    public int TrangThaiId { get; set; }
    public string TrangThaiDanhMucText { get; set; }
    public string GhiChu { get; set; }
    public DateTime CreatedOnUtc { get; set; }
    public DateTime? UpdatedOnUtc { get; set; }
}
