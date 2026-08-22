using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum MucXepLoaiLaoDongTypes
    {
        [Description("Hoàn thành xuất sắc nhiệm vụ")]
        HoanThanhXuatSac = 1,
        [Description("Hoàn thành tốt nhiệm vụ")]
        HoanThanhTot = 2,
        [Description("Hoàn thành nhiệm vụ")]
        HoanThanh = 3,
        [Description("Không hoàn thành nhiệm vụ")]
        KhongHoanThanh = 4,
    }
}
