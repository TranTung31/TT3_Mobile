using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum KetQuaPhanLoaiLaoDongType
    {
        [Description("Hoàn thành xuất sắc nhiệm vụ")]
        HoanThanhXuatSacNhiemVu = 1,
        [Description("Hoàn thành tốt nhiệm vụ")]
        HoanThanhTotNhiemVu = 2,
        [Description("Hoàn thành nhiệm vụ")]
        HoanThanhNhiemVu = 3,
        [Description("Không hoàn thành nhiệm vụ")]
        KhongHoanThanhNhiemVu = 4
    }
}
