import 'package:qltstc_kiemke/models/taisan.dart';

class TaiSanMobile {
  String? id;
  String? taiSanId;
  String? bienBanId;
  String? tenTaiSan;
  String? maTaiSan;
  String? maDiaBan;
  int? soLuong;
  int? soLuongKiemKe;
  String? chungLoai;
  String? ngayTinh;
  int? daGiam;
  int? changeIndex;
  String? maKetQuaXuLy;
  String? maHinhThucXuLy;
  String? soQuyetDinh;
  String? maTaiSanGhiGiam;
  String? taiSanGhiGiamId;
  String? taiSanGhiTangId;
  String? maTaiSanGhiTang;
  String? ngayQuyetDinh;
  double? nguyenGia;
  double? haoMonTrongNam;
  double? haoMonLuyKe;
  double? khauHaoTrongNam;
  double? khauHaoLuyKe;
  double? giaTriConLai;
  String? boPhanSuDungId;
  String? doiTuongSuDungId;
  String? maTinhTrangSuDung;
  String? maHinhThucSuDung;
  String? maHienTrangSuDung;
  double? dienTich;
  double? tichLuongKho;
  double? tichLuongKhoKiemKe;
  String? namSuDung;
  int? soTang;
  String? bienKiemSoat;
  String? nhanHieu;
  int? soChoNgoi;
  String? congXuat;
  int? namSanXuat;
  String? nuocSanXuat;
  String? nhomTaiSanId;
  String? maNhomTaiSan;
  String? nhomTaiSan;
  String? diaChi;
  String? bienDongId;
  int? loaiTaiSanGoc;
  String? tenBienDongTaiSan;
  double? loaiBienDong;
  String? tenLoaiBienDong;
  String? maBienDongTaiSan;
  String? ngayBienDong;
  String? maPhanCap;
  bool? taiSanGhiGiam;
  String? maChungLoai;
  String? hinhThucSuDungChuyenDung;
  String? bpsdId;
  String? donViId;
  String? duAnId;
  bool? pheDuyetQuyetToan;
  String? xuLyTaiSan;
  bool? isChon;
  bool? isXuLy;
  String? trangThaiXuLy;
  bool? pheDuyetPASX;
  String? phuongAnSXXL;
  String? soKyHieuPD;
  String? ngayPheDuyet;
  String? tenBPSD;
  String? tenDTSD;

  TaiSanMobile({
    this.id,
    this.taiSanId,
    this.bienBanId,
    this.tenTaiSan,
    this.maTaiSan,
    this.maDiaBan,
    this.soLuong,
    this.soLuongKiemKe,
    this.chungLoai,
    this.ngayTinh,
    this.daGiam,
    this.changeIndex,
    this.maKetQuaXuLy,
    this.maHinhThucXuLy,
    this.soQuyetDinh,
    this.maTaiSanGhiGiam,
    this.taiSanGhiGiamId,
    this.taiSanGhiTangId,
    this.maTaiSanGhiTang,
    this.ngayQuyetDinh,
    this.nguyenGia,
    this.haoMonTrongNam,
    this.haoMonLuyKe,
    this.khauHaoTrongNam,
    this.khauHaoLuyKe,
    this.giaTriConLai,
    this.boPhanSuDungId,
    this.doiTuongSuDungId,
    this.maTinhTrangSuDung,
    this.maHinhThucSuDung,
    this.maHienTrangSuDung,
    this.dienTich,
    this.tichLuongKho,
    this.tichLuongKhoKiemKe,
    this.namSuDung,
    this.soTang,
    this.bienKiemSoat,
    this.nhanHieu,
    this.soChoNgoi,
    this.congXuat,
    this.namSanXuat,
    this.nuocSanXuat,
    this.nhomTaiSanId,
    this.maNhomTaiSan,
    this.nhomTaiSan,
    this.diaChi,
    this.bienDongId,
    this.loaiTaiSanGoc,
    this.tenBienDongTaiSan,
    this.loaiBienDong,
    this.tenLoaiBienDong,
    this.maBienDongTaiSan,
    this.ngayBienDong,
    this.maPhanCap,
    this.taiSanGhiGiam,
    this.maChungLoai,
    this.hinhThucSuDungChuyenDung,
    this.bpsdId,
    this.donViId,
    this.duAnId,
    this.pheDuyetQuyetToan,
    this.xuLyTaiSan,
    this.isChon,
    this.isXuLy,
    this.trangThaiXuLy,
    this.pheDuyetPASX,
    this.phuongAnSXXL,
    this.soKyHieuPD,
    this.ngayPheDuyet,
    this.tenBPSD,
    this.tenDTSD,
  });

  TaiSanMobile.fromJson(Map<String, dynamic> json) {
    id = json['Id']?.toString();
    taiSanId = json['TaiSanId']?.toString();
    bienBanId = json['BienBanId']?.toString();
    tenTaiSan = json['TenTaiSan']?.toString();
    maTaiSan = json['MaTaiSan']?.toString();
    maDiaBan = json['MaDiaBan']?.toString();
    soLuong = json['SoLuong']?.toInt();
    soLuongKiemKe = json['SoLuongKiemKe']?.toInt();
    chungLoai = json['ChungLoai']?.toString();
    ngayTinh = json['NgayTinh']?.toString();
    daGiam = json['Da_Giam']?.toInt();
    changeIndex = json['ChangeIndex']?.toInt();
    maKetQuaXuLy = json['MaKetQuaXuLy']?.toString();
    maHinhThucXuLy = json['MaHinhThucXuLy']?.toString();
    soQuyetDinh = json['SoQuyetDinh']?.toString();
    maTaiSanGhiGiam = json['MaTaiSanGhiGiam']?.toString();
    taiSanGhiGiamId = json['TaiSanGhiGiamId']?.toString();
    taiSanGhiTangId = json['TaiSanGhiTangId']?.toString();
    maTaiSanGhiTang = json['MaTaiSanGhiTang']?.toString();
    ngayQuyetDinh = json['NgayQuyetDinh']?.toString();
    nguyenGia = json['NguyenGia']?.toDouble();
    haoMonTrongNam = json['HaoMonTrongNam']?.toDouble();
    haoMonLuyKe = json['HaoMonLuyKe']?.toDouble();
    khauHaoTrongNam = json['KhauHaoTrongNam']?.toDouble();
    khauHaoLuyKe = json['KhauHaoLuyKe']?.toDouble();
    giaTriConLai = json['GiaTriConLai']?.toDouble();
    boPhanSuDungId = json['BoPhanSuDungId']?.toString();
    doiTuongSuDungId = json['DoiTuongSuDungId']?.toString();
    maTinhTrangSuDung = json['MaTinhTrangSuDung']?.toString();
    maHinhThucSuDung = json['MaHinhThucSuDung']?.toString();
    maHienTrangSuDung = json['MaHienTrangSuDung']?.toString();
    dienTich = json['DienTich']?.toDouble();
    tichLuongKho = json['TichLuongKho']?.toDouble();
    tichLuongKhoKiemKe = json['TichLuongKhoKiemKe']?.toDouble();
    namSuDung = json['NamSuDung']?.toString();
    soTang = json['SoTang']?.toInt();
    bienKiemSoat = json['BienKiemSoat']?.toString();
    nhanHieu = json['NhanHieu']?.toString();
    soChoNgoi = json['SoChoNgoi']?.toInt();
    congXuat = json['CongXuat']?.toString();
    namSanXuat = json['NamSanXuat']?.toInt();
    nuocSanXuat = json['NuocSanXuat']?.toString();
    nhomTaiSanId = json['NhomTaiSanId']?.toString();
    maNhomTaiSan = json['MaNhomTaiSan']?.toString();
    nhomTaiSan = json['NhomTaiSan']?.toString();
    diaChi = json['DiaChi']?.toString();
    bienDongId = json['BienDongId']?.toString();
    loaiTaiSanGoc = json['LoaiTaiSanGoc']?.toInt();
    tenBienDongTaiSan = json['TenBienDongTaiSan']?.toString();
    loaiBienDong = json['LoaiBienDong']?.toDouble();
    tenLoaiBienDong = json['TenLoaiBienDong']?.toString();
    maBienDongTaiSan = json['MaBienDongTaiSan']?.toString();
    ngayBienDong = json['NgayBienDong']?.toString();
    maPhanCap = json['MaPhanCap']?.toString();
    taiSanGhiGiam = json['TaiSanGhiGiam'] as bool?;
    maChungLoai = json['MaChungLoai']?.toString();
    hinhThucSuDungChuyenDung = json['HinhThucSuDungChuyenDung']?.toString();
    bpsdId = json['BPSD_Id']?.toString();
    donViId = json['DonViId']?.toString();
    duAnId = json['DuAnId']?.toString();
    pheDuyetQuyetToan = json['PheDuyetQuyetToan'] as bool?;
    xuLyTaiSan = json['XuLyTaiSan']?.toString();
    isChon = json['IsChon'] as bool?;
    isXuLy = json['IsXuLy'] as bool?;
    trangThaiXuLy = json['TrangThaiXuLy']?.toString();
    pheDuyetPASX = json['PheDuyetPASX'] as bool?;
    phuongAnSXXL = json['PhuongAnSXXL']?.toString();
    soKyHieuPD = json['SoKyHieuPD']?.toString();
    ngayPheDuyet = json['NgayPheDuyet']?.toString();
    tenBPSD = json['TenBPSD']?.toString();
    tenDTSD = json['TenDTSD']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['TaiSanId'] = taiSanId;
    data['BienBanId'] = bienBanId;
    data['TenTaiSan'] = tenTaiSan;
    data['MaTaiSan'] = maTaiSan;
    data['MaDiaBan'] = maDiaBan;
    data['SoLuong'] = soLuong;
    data['SoLuongKiemKe'] = soLuongKiemKe;
    data['ChungLoai'] = chungLoai;
    data['NgayTinh'] = ngayTinh;
    data['Da_Giam'] = daGiam;
    data['ChangeIndex'] = changeIndex;
    data['MaKetQuaXuLy'] = maKetQuaXuLy;
    data['MaHinhThucXuLy'] = maHinhThucXuLy;
    data['SoQuyetDinh'] = soQuyetDinh;
    data['MaTaiSanGhiGiam'] = maTaiSanGhiGiam;
    data['TaiSanGhiGiamId'] = taiSanGhiGiamId;
    data['TaiSanGhiTangId'] = taiSanGhiTangId;
    data['MaTaiSanGhiTang'] = maTaiSanGhiTang;
    data['NgayQuyetDinh'] = ngayQuyetDinh;
    data['NguyenGia'] = nguyenGia;
    data['HaoMonTrongNam'] = haoMonTrongNam;
    data['HaoMonLuyKe'] = haoMonLuyKe;
    data['KhauHaoTrongNam'] = khauHaoTrongNam;
    data['KhauHaoLuyKe'] = khauHaoLuyKe;
    data['GiaTriConLai'] = giaTriConLai;
    data['BoPhanSuDungId'] = boPhanSuDungId;
    data['DoiTuongSuDungId'] = doiTuongSuDungId;
    data['MaTinhTrangSuDung'] = maTinhTrangSuDung;
    data['MaHinhThucSuDung'] = maHinhThucSuDung;
    data['MaHienTrangSuDung'] = maHienTrangSuDung;
    data['DienTich'] = dienTich;
    data['TichLuongKho'] = tichLuongKho;
    data['TichLuongKhoKiemKe'] = tichLuongKhoKiemKe;
    data['NamSuDung'] = namSuDung;
    data['SoTang'] = soTang;
    data['BienKiemSoat'] = bienKiemSoat;
    data['NhanHieu'] = nhanHieu;
    data['SoChoNgoi'] = soChoNgoi;
    data['CongXuat'] = congXuat;
    data['NamSanXuat'] = namSanXuat;
    data['NuocSanXuat'] = nuocSanXuat;
    data['NhomTaiSanId'] = nhomTaiSanId;
    data['MaNhomTaiSan'] = maNhomTaiSan;
    data['NhomTaiSan'] = nhomTaiSan;
    data['DiaChi'] = diaChi;
    data['BienDongId'] = bienDongId;
    data['LoaiTaiSanGoc'] = loaiTaiSanGoc;
    data['TenBienDongTaiSan'] = tenBienDongTaiSan;
    data['LoaiBienDong'] = loaiBienDong;
    data['TenLoaiBienDong'] = tenLoaiBienDong;
    data['MaBienDongTaiSan'] = maBienDongTaiSan;
    data['NgayBienDong'] = ngayBienDong;
    data['MaPhanCap'] = maPhanCap;
    data['TaiSanGhiGiam'] = taiSanGhiGiam;
    data['MaChungLoai'] = maChungLoai;
    data['HinhThucSuDungChuyenDung'] = hinhThucSuDungChuyenDung;
    data['BPSD_Id'] = bpsdId;
    data['DonViId'] = donViId;
    data['DuAnId'] = duAnId;
    data['PheDuyetQuyetToan'] = pheDuyetQuyetToan;
    data['XuLyTaiSan'] = xuLyTaiSan;
    data['IsChon'] = isChon;
    data['IsXuLy'] = isXuLy;
    data['TrangThaiXuLy'] = trangThaiXuLy;
    data['PheDuyetPASX'] = pheDuyetPASX;
    data['PhuongAnSXXL'] = phuongAnSXXL;
    data['SoKyHieuPD'] = soKyHieuPD;
    data['NgayPheDuyet'] = ngayPheDuyet;
    data['TenBPSD'] = tenBPSD;
    data['TenDTSD'] = tenDTSD;
    return data;
  }

  /// Convert a list dynamic to a list TaiSanMobile
  static List<TaiSanMobile> listFromJson(List<dynamic> list) {
    List<TaiSanMobile> rows =
        list.map((i) => TaiSanMobile.fromJson(i)).toList();
    return rows;
  }

  /// Convert TaiSanMobile to TaiSan (existing model)
  TaiSan convertToTaiSan() {
    var taiSan = TaiSan(
      maTS: maTaiSan,
      tenTS: tenTaiSan,
      tenNhomTS: nhomTaiSan,
      ngaySuDung: namSuDung,
      ngayBienDong: ngayBienDong,
      namSanXuat: namSanXuat,
      nuocSanXuat: nuocSanXuat,
      thongSoKyThuat: null, // Not available in TaiSanMobile
      nguyenGia: nguyenGia,
      nguyenGiaGoc: nguyenGia, // Using same value
      congSuat: congXuat,
      qrCode: null, // Not available in TaiSanMobile
      nguyenGiaText: null, // Not available in TaiSanMobile
      namSuDung: namSuDung,
      tsId: taiSanId,
      loaiTaiSanGoc: loaiTaiSanGoc,
      changeIndex: changeIndex,
      daGiam: daGiam,
      ngayTinh: ngayTinh,
      soLuong: soLuong ?? 1,
      khoiLuongSoLuong: tichLuongKho?.toInt() ?? 0,
      haoMonNam: haoMonTrongNam?.toInt() ?? 0,
      haoMonLuyKe: haoMonLuyKe?.toInt() ?? 0,
      khauHaoNam: khauHaoTrongNam?.toInt() ?? 0,
      maDiaBan: maDiaBan,
      khauHaoLuyKe: khauHaoLuyKe?.toInt() ?? 0,
      giaTriConLai: giaTriConLai,
      BPSDTSID: boPhanSuDungId,
      DTSDTSID: doiTuongSuDungId,
      maTinhTrangSuDung: maTinhTrangSuDung,
      maHinhThucSuDung: maHinhThucSuDung,
      maHienTrangSuDung: maHienTrangSuDung,
      pheDuyetQuyetToan: pheDuyetQuyetToan,
      tongDienTich: dienTich?.toInt() ?? 0,
      soTang: soTang,
      bienKiemSoat: bienKiemSoat,
      nhanHieu: nhanHieu,
      soChoNgoi: soChoNgoi,
      donViId: donViId,
      nhomTaiSanId: nhomTaiSanId,
      loanBienDong: loaiBienDong?.toInt() ?? 0,
      chungLoai: chungLoai,
      diaChiNha: diaChi, // Using diaChi for both
      diaChiDat: diaChi,
      hinhThucSuDungChuyenNhuong: hinhThucSuDungChuyenDung,
      maHinhThucXuLy: maHinhThucXuLy,
      hasScanned: false,
      tenBPSDTS: tenBPSD,
      tenDTSDTS: tenDTSD,
    );

    // Set soLuongKiemKe after creation
    taiSan.soLuongKiemKe = soLuongKiemKe ?? 0;
    return taiSan;
  }
}
