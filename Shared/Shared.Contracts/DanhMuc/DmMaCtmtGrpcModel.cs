namespace Shared.Contracts.DanhMuc;

public class DmMaCtmtGrpcModel
{
    public Guid Id { get; set; }
    public  string Ma { get; set; }
    public  string Ten { get; set; }
    public Guid? MaCtmtChaId { get; set; }
}
