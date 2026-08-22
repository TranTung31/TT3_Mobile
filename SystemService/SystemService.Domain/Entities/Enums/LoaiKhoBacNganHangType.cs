using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums {
	public enum LoaiKhoBacNganHangType {
		[Description("Kho bạc nhà nước")]
		KhoBacNhaNuoc = 1,

		[Description("Ngân hàng thương mại")]
		NganHangThuongMai = 2,

		[Description("Ngân hàng chính sách")]
		NganHangChinhSach = 3,

		[Description("Ngân hàng phát triển")]
		NganHangPhatTrien = 4,

		[Description("Khác")]
		Khac = 5,
	}
}
