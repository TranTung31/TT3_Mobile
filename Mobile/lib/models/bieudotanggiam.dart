class TangGiamChiTiet {
  final String loaiTaiSan;
  final double? dkSl;
  final double? tangSl;
  final double? giamSl;
  final double? ckSl;
  final int loaiTaiSanGoc;

  TangGiamChiTiet({
    required this.loaiTaiSan,
    this.dkSl,
    this.tangSl,
    this.giamSl,
    this.ckSl,
    required this.loaiTaiSanGoc,
  });

  factory TangGiamChiTiet.fromJson(Map<String, dynamic> json) {
    return TangGiamChiTiet(
      loaiTaiSan: json['LOAI_TAI_SAN'] ?? '',
      dkSl: json['DK_SL']?.toDouble(),
      tangSl: json['TANG_SL']?.toDouble(),
      giamSl: json['GIAM_SL']?.toDouble(),
      ckSl: json['CK_SL']?.toDouble(),
      loaiTaiSanGoc: json['LOAI_TAI_SAN_GOC'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LOAI_TAI_SAN': loaiTaiSan,
      'DK_SL': dkSl,
      'TANG_SL': tangSl,
      'GIAM_SL': giamSl,
      'CK_SL': ckSl,
      'LOAI_TAI_SAN_GOC': loaiTaiSanGoc,
    };
  }
}

class BieuDoTangGiam {
  final double tongDkSl;
  final double tongTangSl;
  final double tongGiamSl;
  final double tongCkSl;
  final List<TangGiamChiTiet> tangGiamChiTiets;

  BieuDoTangGiam({
    required this.tongDkSl,
    required this.tongTangSl,
    required this.tongGiamSl,
    required this.tongCkSl,
    required this.tangGiamChiTiets,
  });

  factory BieuDoTangGiam.fromJson(Map<String, dynamic> json) {
    return BieuDoTangGiam(
      tongDkSl: (json['TONG_DK_SL'] ?? 0).toDouble(),
      tongTangSl: (json['TONG_TANG_SL'] ?? 0).toDouble(),
      tongGiamSl: (json['TONG_GIAM_SL'] ?? 0).toDouble(),
      tongCkSl: (json['TONG_CK_SL'] ?? 0).toDouble(),
      tangGiamChiTiets: (json['TANG_GIAM_CHI_TIETS'] as List<dynamic>?)
              ?.map((item) => TangGiamChiTiet.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TONG_DK_SL': tongDkSl,
      'TONG_TANG_SL': tongTangSl,
      'TONG_GIAM_SL': tongGiamSl,
      'TONG_CK_SL': tongCkSl,
      'TANG_GIAM_CHI_TIETS': tangGiamChiTiets.map((item) => item.toJson()).toList(),
    };
  }
}
