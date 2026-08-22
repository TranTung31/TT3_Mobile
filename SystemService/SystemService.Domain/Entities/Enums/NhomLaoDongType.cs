using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum NhomLaoDongType
    {
        [Description("Lao động biên chế")]
        LaoDongBienChe = 1,
        [Description("Lao động hợp đồng")]
        LaoDonghopDong = 2,
        [Description("Lao động thời vụ")]
        LaoDongThoiVu = 3
    }
}
