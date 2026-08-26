class BieuDoTongHop {
  final String loaiTaiSan;
  final double soLuong;
  final double nguyenGia;
  final int loaiTaiSanGoc;

  BieuDoTongHop({
    required this.loaiTaiSan,
    required this.soLuong,
    required this.nguyenGia,
    required this.loaiTaiSanGoc,
  });

  factory BieuDoTongHop.fromJson(Map<String, dynamic> json) {
    return BieuDoTongHop(
      loaiTaiSan: json['LOAI_TAI_SAN'] ?? '',
      soLuong: (json['SO_LUONG'] ?? 0).toDouble(),
      nguyenGia: (json['NGUYEN_GIA'] ?? 0).toDouble(),
      loaiTaiSanGoc: json['LOAI_TAI_SAN_GOC'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LOAI_TAI_SAN': loaiTaiSan,
      'SO_LUONG': soLuong,
      'NGUYEN_GIA': nguyenGia,
      'LOAI_TAI_SAN_GOC': loaiTaiSanGoc,
    };
  }

  static List<BieuDoTongHop> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => BieuDoTongHop.fromJson(json))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<BieuDoTongHop> items) {
    return items.map((item) => item.toJson()).toList();
  }
}
