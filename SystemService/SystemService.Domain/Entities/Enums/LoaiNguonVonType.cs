using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Domain.Entities.Enums
{
    public enum LoaiNguonVonType
    {
        [Description("Đầu tư ngân sách trung ương")]
        DautuNganSachTrungUong = 1,
        [Description("Đầu tư nguồn thu hợp pháp")]
        DautuNguonThuHopPhap = 2,
        [Description("Nguồn chi thường xuyên")]
        NguonChiThuongXuyen = 3,
        [Description("Nguồn khác")]
        NguonKhac = 4
    }
}
