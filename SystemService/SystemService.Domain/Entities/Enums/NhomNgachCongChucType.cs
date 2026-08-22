using System.ComponentModel;

namespace SystemService.Domain.Entities.DanhMucDungRiengDonVi.Enums
{
    public enum NhomNgachCongChucType
    {
        [Description("Chuyên viên cao cấp")]
        ChuyenVienCaoCap = 1,
        [Description("Chuyên viên chính")]
        ChuyenVienChinh = 2,
        [Description("Chuyên viên")]
        ChuyenVien = 3,
        [Description("Cán sự")]
        CanSu = 4,
        [Description("Nhân viên")]
        NhanVien = 5,
    }
}
