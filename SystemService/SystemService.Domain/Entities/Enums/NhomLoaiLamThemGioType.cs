using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums
{
    public enum NhomLoaiLamThemGioType
    {
        [Description("Làm thêm giờ")]
        LamThemGio = 1,
        [Description("Ca đêm")]
        CaDem = 2,
        [Description("Không nghỉ phép năm")]
        KhongNghiPhep = 3,
    }
}
