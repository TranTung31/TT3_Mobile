using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum HieuLucType
    {
        [Description("Hiệu lực")]
        HieuLuc = 1,
        [Description("Hết hiệu lực")]
        HetHieuLuc = 2,
    }
}
