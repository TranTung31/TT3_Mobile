using System.ComponentModel;

namespace SystemService.Domain.Entities.Enums {
	public enum LoaiThueType {
		[Description("Thuế trực thu")]
		ThueTrucThu = 1,
		[Description("Thuế gián thu")]
		ThueGianThu = 2,
	}
}
