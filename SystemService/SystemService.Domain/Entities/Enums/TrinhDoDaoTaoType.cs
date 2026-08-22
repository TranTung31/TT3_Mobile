using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum TrinhDoDaoTaoType
    {
        [Description("Giáo dục Phổ thông")]
        PhoThong = 1,        
        [Description("Giáo dục Đại học")]
        DaiHoc = 2,
        [Description("Giáo dục Nghề nghiệp")]
        NgheNghiep = 3,
    }
}
