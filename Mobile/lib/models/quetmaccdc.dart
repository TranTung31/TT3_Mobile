class QuetMaCCDC {
  /*
{
    "Id": "128cb2af-f877-473f-a36f-b977758bb5a3",
    "HiId": "b3cad253-aa05-4655-a65b-fb0fbc91d963",
    "PhanBoId": "cfb60a59-cb24-415d-9f4b-098adc5bb959",
    "CongCuId": "d1c34fff-7677-4a0b-ab69-0e742396eec0",
    "MaCongCu": "001453367",
    "MaCongCuOld": null,
    "MaLo": "BLV01",
    "TenCongCu": "Bàn làm việc",
    "DonViId": "b1ccc8c3-9836-440a-affd-0fcfd8fa1a03",
    "MaDonVi": "3026592",
    "TenDonVi": null,
    "NhomCongCuId": "8f156a9e-8b86-4dec-b700-28886ca3449c",
    "MaNhomCongCu": "BLV01",
    "TenNhomCongCu": "Bàn làm việc",
    "NgayPhanBo": "2017-07-07T00:00:00",
    "NgayPhatSinh": null,
    "DonViTinh": "Cái",
    "DonGia": 1815000.0,
    "GiaTri": null,
    "SoLuong": 1,
    "SoLuongSuDung": 1,
    "SoLuongChoThueSuaChua": null,
    "TyLePhanBo": 0.0,
    "SoThangPhanBo": 0,
    "HinhThucPhanBo": 1,
    "LoaiBienDong": 2,
    "TenLoaiBienDong": null,
    "SoChungTu": null,
    "NgayChungTu": null,
    "DienGiai": null,
    "TrangThai": 2.0,
    "NguoiTao": "60_nv_bqldadtxdcn.nguyendinhdung",
    "NgayTao": "2018-01-30T09:43:17",
    "MaBPSDTS": "6000101",
    "TenBPSDTS": "Ban quản lý dự án ",
    "BPSDTS_Id": "2ea08d66-dd13-4eac-8961-c5e251db3e94",
    "TenDTSDTS": null,
    "DTSDTS_Id": null,
    "MaTinhTrang": "001",
    "LyDo": null,
    "MaNguonGoc": null,
    "NgayGiam": null,
    "AsCongCuGiamId": null,
    "HiCongCuId": null,
    "AsCongCuDieuChuyenId": null,
    "HiCongCuSuDungId": null,
    "HiCongCuSuDungMoiId": null,
    "LaDieuChuyenTheoLo": null,
    "LoCcdcDcId": null,
    "IsHasData": null,
    "BPSDTS_DieuChinh_Id": null,
    "DTSDTS_DieuChinh_Id": null,
    "TenBPSDTS_DieuChinh": null,
    "TenDTSDTS_DieuChinh": null,
    "IsNew": true
}
*/

  String? id;
  String? hiId;
  String? phanBoId;
  String? congCuId;
  String? maCongCu;
  String? maCongCuOld;
  String? maLo;
  String? tenCongCu;
  String? donViId;
  String? maDonVi;
  String? tenDonVi;
  String? nhomCongCuId;
  String? maNhomCongCu;
  String? tenNhomCongCu;
  String? ngayPhanBo;
  String? ngayPhatSinh;
  String? donViTinh;
  double? donGia;
  double? giaTri;
  int? soLuong;
  int? soLuongSuDung;
  int? soLuongChoThueSuaChua;
  double? tyLePhanBo;
  int? soThangPhanBo;
  int? hinhThucPhanBo;
  int? loaiBienDong;
  String? tenLoaiBienDong;
  String? soChungTu;
  String? ngayChungTu;
  String? dienGiai;
  double? trangThai;
  String? nguoiTao;
  String? ngayTao;
  String? maBPSDTS;
  String? tenBPSDTS;
  String? bpsdtsId;
  String? tenDTSDTS;
  String? dtsdtsId;
  String? maTinhTrang;
  String? lyDo;
  String? maNguonGoc;
  String? ngayGiam;
  String? asCongCuGiamId;
  String? hiCongCuId;
  String? asCongCuDieuChuyenId;
  String? hiCongCuSuDungId;
  String? hiCongCuSuDungMoiId;
  bool? laDieuChuyenTheoLo;
  String? loCcdcDcId;
  bool? isHasData;
  String? bpsdtsDieuChinhId;
  String? dtsdtsDieuChinhId;
  String? tenBPSDTSDieuChinh;
  String? tenDTSDTSDieuChinh;
  bool? isNew;

  QuetMaCCDC({
    this.id,
    this.hiId,
    this.phanBoId,
    this.congCuId,
    this.maCongCu,
    this.maCongCuOld,
    this.maLo,
    this.tenCongCu,
    this.donViId,
    this.maDonVi,
    this.tenDonVi,
    this.nhomCongCuId,
    this.maNhomCongCu,
    this.tenNhomCongCu,
    this.ngayPhanBo,
    this.ngayPhatSinh,
    this.donViTinh,
    this.donGia,
    this.giaTri,
    this.soLuong,
    this.soLuongSuDung,
    this.soLuongChoThueSuaChua,
    this.tyLePhanBo,
    this.soThangPhanBo,
    this.hinhThucPhanBo,
    this.loaiBienDong,
    this.tenLoaiBienDong,
    this.soChungTu,
    this.ngayChungTu,
    this.dienGiai,
    this.trangThai,
    this.nguoiTao,
    this.ngayTao,
    this.maBPSDTS,
    this.tenBPSDTS,
    this.bpsdtsId,
    this.tenDTSDTS,
    this.dtsdtsId,
    this.maTinhTrang,
    this.lyDo,
    this.maNguonGoc,
    this.ngayGiam,
    this.asCongCuGiamId,
    this.hiCongCuId,
    this.asCongCuDieuChuyenId,
    this.hiCongCuSuDungId,
    this.hiCongCuSuDungMoiId,
    this.laDieuChuyenTheoLo,
    this.loCcdcDcId,
    this.isHasData,
    this.bpsdtsDieuChinhId,
    this.dtsdtsDieuChinhId,
    this.tenBPSDTSDieuChinh,
    this.tenDTSDTSDieuChinh,
    this.isNew,
  });

  QuetMaCCDC.fromJson(Map<String, dynamic> json) {
    id = json['Id']?.toString();
    hiId = json['HiId']?.toString();
    phanBoId = json['PhanBoId']?.toString();
    congCuId = json['CongCuId']?.toString();
    maCongCu = json['MaCongCu']?.toString();
    maCongCuOld = json['MaCongCuOld']?.toString();
    maLo = json['MaLo']?.toString();
    tenCongCu = json['TenCongCu']?.toString();
    donViId = json['DonViId']?.toString();
    maDonVi = json['MaDonVi']?.toString();
    tenDonVi = json['TenDonVi']?.toString();
    nhomCongCuId = json['NhomCongCuId']?.toString();
    maNhomCongCu = json['MaNhomCongCu']?.toString();
    tenNhomCongCu = json['TenNhomCongCu']?.toString();
    ngayPhanBo = json['NgayPhanBo']?.toString();
    ngayPhatSinh = json['NgayPhatSinh']?.toString();
    donViTinh = json['DonViTinh']?.toString();
    donGia = json['DonGia']?.toDouble();
    giaTri = json['GiaTri']?.toDouble();
    soLuong = json['SoLuong']?.toInt();
    soLuongSuDung = json['SoLuongSuDung']?.toInt();
    soLuongChoThueSuaChua = json['SoLuongChoThueSuaChua']?.toInt();
    tyLePhanBo = json['TyLePhanBo']?.toDouble();
    soThangPhanBo = json['SoThangPhanBo']?.toInt();
    hinhThucPhanBo = json['HinhThucPhanBo']?.toInt();
    loaiBienDong = json['LoaiBienDong']?.toInt();
    tenLoaiBienDong = json['TenLoaiBienDong']?.toString();
    soChungTu = json['SoChungTu']?.toString();
    ngayChungTu = json['NgayChungTu']?.toString();
    dienGiai = json['DienGiai']?.toString();
    trangThai = json['TrangThai']?.toDouble();
    nguoiTao = json['NguoiTao']?.toString();
    ngayTao = json['NgayTao']?.toString();
    maBPSDTS = json['MaBPSDTS']?.toString();
    tenBPSDTS = json['TenBPSDTS']?.toString();
    bpsdtsId = json['BPSDTS_Id']?.toString();
    tenDTSDTS = json['TenDTSDTS']?.toString();
    dtsdtsId = json['DTSDTS_Id']?.toString();
    maTinhTrang = json['MaTinhTrang']?.toString();
    lyDo = json['LyDo']?.toString();
    maNguonGoc = json['MaNguonGoc']?.toString();
    ngayGiam = json['NgayGiam']?.toString();
    asCongCuGiamId = json['AsCongCuGiamId']?.toString();
    hiCongCuId = json['HiCongCuId']?.toString();
    asCongCuDieuChuyenId = json['AsCongCuDieuChuyenId']?.toString();
    hiCongCuSuDungId = json['HiCongCuSuDungId']?.toString();
    hiCongCuSuDungMoiId = json['HiCongCuSuDungMoiId']?.toString();
    laDieuChuyenTheoLo = json['LaDieuChuyenTheoLo'];
    loCcdcDcId = json['LoCcdcDcId']?.toString();
    isHasData = json['IsHasData'];
    bpsdtsDieuChinhId = json['BPSDTS_DieuChinh_Id']?.toString();
    dtsdtsDieuChinhId = json['DTSDTS_DieuChinh_Id']?.toString();
    tenBPSDTSDieuChinh = json['TenBPSDTS_DieuChinh']?.toString();
    tenDTSDTSDieuChinh = json['TenDTSDTS_DieuChinh']?.toString();
    isNew = json['IsNew'];
  }

  /// convert a list dynamic to a list QuetMaCCDC
  static List<QuetMaCCDC> listFromJson(List<dynamic> list) {
    List<QuetMaCCDC> rows = list.map((i) => QuetMaCCDC.fromJson(i)).toList();
    return rows;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['HiId'] = hiId;
    data['PhanBoId'] = phanBoId;
    data['CongCuId'] = congCuId;
    data['MaCongCu'] = maCongCu;
    data['MaCongCuOld'] = maCongCuOld;
    data['MaLo'] = maLo;
    data['TenCongCu'] = tenCongCu;
    data['DonViId'] = donViId;
    data['MaDonVi'] = maDonVi;
    data['TenDonVi'] = tenDonVi;
    data['NhomCongCuId'] = nhomCongCuId;
    data['MaNhomCongCu'] = maNhomCongCu;
    data['TenNhomCongCu'] = tenNhomCongCu;
    data['NgayPhanBo'] = ngayPhanBo;
    data['NgayPhatSinh'] = ngayPhatSinh;
    data['DonViTinh'] = donViTinh;
    data['DonGia'] = donGia;
    data['GiaTri'] = giaTri;
    data['SoLuong'] = soLuong;
    data['SoLuongSuDung'] = soLuongSuDung;
    data['SoLuongChoThueSuaChua'] = soLuongChoThueSuaChua;
    data['TyLePhanBo'] = tyLePhanBo;
    data['SoThangPhanBo'] = soThangPhanBo;
    data['HinhThucPhanBo'] = hinhThucPhanBo;
    data['LoaiBienDong'] = loaiBienDong;
    data['TenLoaiBienDong'] = tenLoaiBienDong;
    data['SoChungTu'] = soChungTu;
    data['NgayChungTu'] = ngayChungTu;
    data['DienGiai'] = dienGiai;
    data['TrangThai'] = trangThai;
    data['NguoiTao'] = nguoiTao;
    data['NgayTao'] = ngayTao;
    data['MaBPSDTS'] = maBPSDTS;
    data['TenBPSDTS'] = tenBPSDTS;
    data['BPSDTS_Id'] = bpsdtsId;
    data['TenDTSDTS'] = tenDTSDTS;
    data['DTSDTS_Id'] = dtsdtsId;
    data['MaTinhTrang'] = maTinhTrang;
    data['LyDo'] = lyDo;
    data['MaNguonGoc'] = maNguonGoc;
    data['NgayGiam'] = ngayGiam;
    data['AsCongCuGiamId'] = asCongCuGiamId;
    data['HiCongCuId'] = hiCongCuId;
    data['AsCongCuDieuChuyenId'] = asCongCuDieuChuyenId;
    data['HiCongCuSuDungId'] = hiCongCuSuDungId;
    data['HiCongCuSuDungMoiId'] = hiCongCuSuDungMoiId;
    data['LaDieuChuyenTheoLo'] = laDieuChuyenTheoLo;
    data['LoCcdcDcId'] = loCcdcDcId;
    data['IsHasData'] = isHasData;
    data['BPSDTS_DieuChinh_Id'] = bpsdtsDieuChinhId;
    data['DTSDTS_DieuChinh_Id'] = dtsdtsDieuChinhId;
    data['TenBPSDTS_DieuChinh'] = tenBPSDTSDieuChinh;
    data['TenDTSDTS_DieuChinh'] = tenDTSDTSDieuChinh;
    data['IsNew'] = isNew;
    return data;
  }
}
