using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums
{
    public enum MenuHeThongType
    {
        [Description("Dashboard")]
        Dashboard = 1,
        [Description("Quản lý tài chính")]
        QuanLyTaiChinh = 2,
        [Description("Quản lý đầu tư")]
        QuanLyDauTu = 3,
        [Description("Kiểm tra kiểm toán")]
        KiemTraKiemToan = 4,
        [Description("Quản trị hệ thống")]
        QuanTriHeThong = 5,
    }
}
