using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum LoaiDoiTuongType
    {
        [Description("Nhà cung cấp nhà thầu")]
        NhaCungCapNhaThau = 1,
        [Description("Khách hàng")]
        KhachHang = 2,
        [Description("Khác")]
        Khac = 3
    }
}
