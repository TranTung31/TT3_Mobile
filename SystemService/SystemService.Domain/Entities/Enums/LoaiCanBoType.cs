using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums {
	public enum LoaiCanBoType {
		[Description("Thủ trưởng đơn vị")]
		ThuTruongDonVi = 1,
		[Description("Kế toán trưởng")]
		KeToanTruong = 2,
		[Description("Kế toán viên")]
		KeToanVien = 3,
		[Description("Thủ quỹ")]
		ThuQuy = 4,
		[Description("Thủ kho")]
		ThuKho = 5,
		[Description("Người lập biểu")]
		NguoiLapBieu = 6,
	}
}
