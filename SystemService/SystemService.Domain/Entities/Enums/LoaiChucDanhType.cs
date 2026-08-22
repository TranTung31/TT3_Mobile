using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums {
	public enum LoaiChucDanhType {
		[Description("Chức danh ký quản lý tài chỉnh")]
		QuanLyTaiChinh = 1,
		[Description("Chức danh ký quản lý đầu tư")]
		QuanLyDauTu = 2,
		[Description("Chức danh ký quản lý kiểm tra, giám sát, kiểm toán")]
		QuanLyKiemTraKiemToan = 3,
	}
}
