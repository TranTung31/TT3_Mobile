using Shared.Contracts.Authentication;
using Shared.Contracts.DanhMuc;

namespace Shared.Contracts.Common
{
    public class DanhMucDictionaryResult
    {
        public Dictionary<Guid, CurrentUser> Users { get; set; } = new();
        public Dictionary<Guid, DmDonViGrpcModel> DonVis { get; set; } = new();
        public Dictionary<Guid, DmNganhLinhVucGrpcModel> NganhLinhVucs { get; set; } = new();
        public Dictionary<Guid, DmNguonVonGrpcModel> NguonVons { get; set; } = new();
    }
}
