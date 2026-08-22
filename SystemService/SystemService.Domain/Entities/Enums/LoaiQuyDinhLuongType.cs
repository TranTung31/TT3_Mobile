using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum LoaiQuyDinhLuongType
    {
        //[Description("Kho tổng hợp")]
        //KhoTongHop = 0,
        [Description("Quy định lương")]
        QuyDinhLuong = 1,
        [Description("Quy định Thuế")]
        QuyDinhThue = 2,
        [Description("Quy định bảo hiểm")]
        QuyDinhBaoHiem = 3
    }
}
