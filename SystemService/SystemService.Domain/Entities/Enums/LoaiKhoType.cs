using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum LoaiKhoType
    {
        [Description("Kho tổng hợp")]
        KhoTongHop = 1,
        [Description("Kho vật tư")]
        KhoVatTu = 2,
        [Description("Kho hàng hóa")]
        KhoHangHoa = 3,
        [Description("Kho công cụ dụng cụ")]
        KhoCongCuDungCu = 4
    } 
}
