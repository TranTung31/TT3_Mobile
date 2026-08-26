class NguoiSuDung {
  late String dtsdtsId;
  late String maDTSDTS;
  late String tenDTSDTS;
  String? diaChi;
  String? dienThoai;
  String? email;
  String? ngayHetHan;
  String? bpsdtsId;
  String? donViId;
  int? value;
  String? text;
  bool? selected;
  String? description;

  NguoiSuDung({
    this.dtsdtsId = "",
    this.maDTSDTS = "",
    this.tenDTSDTS = "",
    this.diaChi,
    this.dienThoai,
    this.email,
    this.ngayHetHan,
    this.bpsdtsId,
    this.donViId,
    this.value,
    this.text,
    this.selected,
    this.description,
  });

  /// Constructor để tạo object từ JSON
  NguoiSuDung.fromJson(Map<String, dynamic> json) {
    dtsdtsId = json['DTSDTS_ID'] ?? "";
    maDTSDTS = json['MaDTSDTS'] ?? "";
    tenDTSDTS = json['TenDTSDTS'] ?? "";
    diaChi = json['DiaChi'];
    dienThoai = json['DienThoai'];
    email = json['Email'];
    ngayHetHan = json['NgayHetHan'];
    bpsdtsId = json['BPSDTS_ID'];
    donViId = json['DonViId'];
    value = json['Value'];
    text = json['Text'];
    selected = json['Selected'];
    description = json['Description'];
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DTSDTS_ID'] = dtsdtsId;
    data['MaDTSDTS'] = maDTSDTS;
    data['TenDTSDTS'] = tenDTSDTS;
    data['DiaChi'] = diaChi;
    data['DienThoai'] = dienThoai;
    data['Email'] = email;
    data['NgayHetHan'] = ngayHetHan;
    data['BPSDTS_ID'] = bpsdtsId;
    data['DonViId'] = donViId;
    data['Value'] = value;
    data['Text'] = text;
    data['Selected'] = selected;
    data['Description'] = description;
    return data;
  }

  /// Tạo list object từ list JSON
  static List<NguoiSuDung> listFromJson(List<dynamic> list) {
    List<NguoiSuDung> rows = list.map((i) => NguoiSuDung.fromJson(i)).toList();
    return rows;
  }

  // /// Copy constructor
  // NguoiSuDung copyWith({
  //   String? dtsdtsId,
  //   String? maDTSDTS,
  //   String? tenDTSDTS,
  //   String? diaChi,
  //   String? dienThoai,
  //   String? email,
  //   String? ngayHetHan,
  //   String? bpsdtsId,
  //   String? donViId,
  //   int? value,
  //   String? text,
  //   bool? selected,
  //   String? description,
  // }) {
  //   return NguoiSuDung(
  //     dtsdtsId: dtsdtsId ?? this.dtsdtsId,
  //     maDTSDTS: maDTSDTS ?? this.maDTSDTS,
  //     tenDTSDTS: tenDTSDTS ?? this.tenDTSDTS,
  //     diaChi: diaChi ?? this.diaChi,
  //     dienThoai: dienThoai ?? this.dienThoai,
  //     email: email ?? this.email,
  //     ngayHetHan: ngayHetHan ?? this.ngayHetHan,
  //     bpsdtsId: bpsdtsId ?? this.bpsdtsId,
  //     donViId: donViId ?? this.donViId,
  //     value: value ?? this.value,
  //     text: text ?? this.text,
  //     selected: selected ?? this.selected,
  //     description: description ?? this.description,
  //   );
  // }

  // @override
  // String toString() {
  //   return 'NguoiSuDung{dtsdtsId: $dtsdtsId, maDTSDTS: $maDTSDTS, tenDTSDTS: $tenDTSDTS, diaChi: $diaChi, dienThoai: $dienThoai, email: $email, ngayHetHan: $ngayHetHan, bpsdtsId: $bpsdtsId, donViId: $donViId, value: $value, text: $text, selected: $selected, description: $description}';
  // }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is NguoiSuDung &&
  //         runtimeType == other.runtimeType &&
  //         dtsdtsId == other.dtsdtsId;

  // @override
  // int get hashCode => dtsdtsId.hashCode;
}
