class NhomTS {
  String? apDungTuNgay;
  String? apDungDenNgay;
  String? nhomTaiSanHisId;
  String? nhomTaiSanId;
  String? maNhomTaiSan;
  String? tenNhomTaiSan;
  double? tyLeHaoMon;
  double? tyLeKhauHao;
  double? thoiGianKhauHaoToiThieu;
  double? thoiGianKhauHaoToiDa;
  int? soNamSuDung;
  int? loaiTaiSanGoc;
  String? maPhanCap;
  String? heThongTaiChinh;
  String? maNhomTaiSanCha;
  int? loaiTaiSanGocCap2;
  bool? laNhomChuyenDung;
  String? key;
  String? title;
  String? tooltip;
  bool? lazy;
  bool? unselectable;
  bool? expanded;
  DateTime? dateExpired;

  NhomTS(
      {this.apDungTuNgay,
      this.apDungDenNgay,
      this.nhomTaiSanHisId,
      this.nhomTaiSanId,
      this.maNhomTaiSan,
      this.tenNhomTaiSan,
      this.tyLeHaoMon,
      this.tyLeKhauHao,
      this.thoiGianKhauHaoToiThieu,
      this.thoiGianKhauHaoToiDa,
      this.soNamSuDung,
      this.loaiTaiSanGoc,
      this.maPhanCap,
      this.maNhomTaiSanCha,
      this.heThongTaiChinh,
      this.loaiTaiSanGocCap2,
      this.laNhomChuyenDung = false,
      this.key,
      this.title,
      this.tooltip,
      this.lazy = false,
      this.unselectable = false,
      this.expanded = false,
      this.dateExpired});

  NhomTS.fromJson(Map<String, dynamic> json) {
    apDungTuNgay = json['apDungTuNgay'];
    apDungDenNgay = json['apDungDenNgay'];
    nhomTaiSanHisId = json['NhomTaiSanHisId'];
    nhomTaiSanId = json['NhomTaiSanId'];
    maNhomTaiSan = json['MaNhomTaiSan'];
    tenNhomTaiSan = json['TenNhomTaiSan'];
    tyLeHaoMon = json['TyLeHaoMon'];
    tyLeKhauHao = json['TyLeKhauHao'];
    thoiGianKhauHaoToiThieu = json['ThoiGianKhauHaoToiThieu'];
    thoiGianKhauHaoToiDa = json['ThoiGianKhauHaoToiDa'];
    soNamSuDung = json['SoNamSuDung'];
    loaiTaiSanGoc = json['LoaiTaiSanGoc'];
    maPhanCap = json['MaPhanCap'];
    maNhomTaiSanCha = json['MaNhomTaiSanCha'];
    heThongTaiChinh = json['HeThongTaiChinh'];
    loaiTaiSanGocCap2 = json['LoaiTaiSanGocCap2'];
    laNhomChuyenDung = json['LaNhomChuyenDung'];
    key = json['key'];
    title = json['title'];
    tooltip = json['tooltip'];
    lazy = json['lazy'];
    unselectable = json['unselectable'];
    expanded = json['expanded'];
    dateExpired = json['dateExpired'];
  }

  static List<NhomTS> listFromJson(List<dynamic> list) {
    List<NhomTS> rows = list.map((i) => NhomTS.fromJson(i)).toList();
    return rows;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apDungTuNgay'] = this.apDungTuNgay;
    data['apDungDenNgay'] = this.apDungDenNgay;
    data['NhomTaiSanHisId'] = this.nhomTaiSanHisId;
    data['NhomTaiSanId'] = this.nhomTaiSanId;
    data['MaNhomTaiSan'] = this.maNhomTaiSan;
    data['TenNhomTaiSan'] = this.tenNhomTaiSan;
    data['TyLeHaoMon'] = this.tyLeHaoMon;
    data['TyLeKhauHao'] = this.tyLeKhauHao;
    data['ThoiGianKhauHaoToiThieu'] = this.thoiGianKhauHaoToiThieu;
    data['ThoiGianKhauHaoToiDa'] = this.thoiGianKhauHaoToiDa;
    data['SoNamSuDung'] = this.soNamSuDung;
    data['LoaiTaiSanGoc'] = this.loaiTaiSanGoc;
    data['MaPhanCap'] = this.maPhanCap;
    data['MaNhomTaiSanCha'] = this.maNhomTaiSanCha;
    data['HeThongTaiChinh'] = this.heThongTaiChinh;
    data['LoaiTaiSanGocCap2'] = this.loaiTaiSanGocCap2;
    data['LaNhomChuyenDung'] = this.laNhomChuyenDung;
    data['key'] = this.key;
    data['title'] = this.title;
    data['tooltip'] = this.tooltip;
    data['lazy'] = this.lazy;
    data['unselectable'] = this.unselectable;
    data['expanded'] = this.expanded;
    data['dateExpired'] = this.dateExpired;
    return data;
  }
}
