using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum NhomKhoanLuongType
    {
        [Description("Lương cơ bản")]
        LuongCoBan = 1,
        [Description("Phụ cấp")]
        PhuCap = 2,
        [Description("Thưởng")]
        Thuong = 3,
        [Description("Khấu trừ")]
        KhauTru = 4
    }
}
