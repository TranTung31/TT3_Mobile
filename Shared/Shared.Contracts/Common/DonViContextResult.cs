using Shared.Contracts.DanhMuc;

namespace Shared.Contracts.Common
{
    public class DonViContextResult
    {
        public Guid DonViId { get; set; }
        public DmDonViGrpcModel DonVi { get; set; }
        public List<Guid> DonViIds { get; set; } = new();
        public Dictionary<Guid, DmDonViGrpcModel> DonVis { get; set; } = new();
        //public List<Guid> DonViChildIds { get; set; } = new();
    }
}
