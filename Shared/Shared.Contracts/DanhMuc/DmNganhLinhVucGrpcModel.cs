namespace Shared.Contracts.DanhMuc;

public class DmNganhLinhVucGrpcModel
{
    public Guid Id { get; set; }
    public string Ma { get; set; }
    public string Ten { get; set; }
    public Guid? NganhLinhVucChaId { get; set; }
}
