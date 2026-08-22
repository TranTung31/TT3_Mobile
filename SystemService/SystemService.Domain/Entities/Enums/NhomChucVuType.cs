using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums
{
    public enum NhomChucVuType
    {
        [Description("Lãnh đạo")]
        LanhDao = 1,
        [Description("Quản lý")]
        QuanLy = 2,
        [Description("Chuyên môn")]
        ChuyenMon = 3,
    }
}
