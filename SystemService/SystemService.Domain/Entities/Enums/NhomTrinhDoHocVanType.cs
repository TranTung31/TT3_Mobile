using System.ComponentModel;

namespace SystemService.Domain.Entities.DanhMucDungRiengDonVi.Enums
{
    public enum NhomTrinhDoHocVanType
    {
        [Description("Phổ thông")]
        PhoThong = 1,
        [Description("Trung cấp")]
        TrungCap = 2,
        [Description("Cao đẳng")]
        CaoDang = 3,
        [Description("Đại học")]
        DaiHoc = 4,
        [Description("Sau đại học")]
        SauDaiHoc = 5,
    }
}
