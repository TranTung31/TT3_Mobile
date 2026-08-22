namespace Shared.Contracts.DanhMuc;

public class DmNguonVonGrpcModel
{
    public Guid Id { get; set; }
    public string Ma { get; set; }
    public string Ten { get; set; }
    public Guid? NguonVonChaId { get; set; }
}
