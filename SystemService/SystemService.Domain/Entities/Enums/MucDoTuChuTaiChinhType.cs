using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum MucDoTuChuTaiChinhType
    {
        [Description("Nhóm 1")]
        NhomMot = 1,
        [Description("Nhóm 2")]
        NhomHai = 2,
        [Description("Nhóm 3")]
        NhomBa = 3,
        [Description("Nhóm 4")]
        NhomBon = 4,
    }
}
