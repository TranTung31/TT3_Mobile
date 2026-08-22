using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum LoaiKhoanLuongType
    {

        [Description("Thu nhập")]
        ThuNhap = 1,
        [Description("Khấu trừ")]
        KhauTru = 2
    }
}

