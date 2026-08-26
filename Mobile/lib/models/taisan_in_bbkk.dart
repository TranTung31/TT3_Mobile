import 'package:qltstc_kiemke/models/taisan.dart';
import 'package:qltstc_kiemke/services/user_service.dart';

class TaiSanInBBKK {
  String? id;
  String? taiSanId;
  String? bienBanId;
  String? tenTaiSan;
  String? maTaiSan;
  dynamic maDiaBan;
  int? soLuong;
  int? soLuongKiemKe;
  String? chungLoai;
  dynamic ngayTinh;
  dynamic daGiam;
  dynamic changeIndex;
  dynamic maKetQuaXuLy;
  dynamic maHinhThucXuLy;
  dynamic soQuyetDinh;
  dynamic maTaiSanGhiGiam;
  dynamic taiSanGhiGiamId;
  dynamic taiSanGhiTangId;
  dynamic maTaiSanGhiTang;
  dynamic ngayQuyetDinh;
  double? nguyenGia;
  double? haoMonTrongNam;
  double? haoMonLuyKe;
  double? khauHaoTrongNam;
  double? khauHaoLuyKe;
  double? giaTriConLai;
  dynamic boPhanSuDungId;
  dynamic doiTuongSuDungId;
  String? maTinhTrangSuDung;
  dynamic maHinhThucSuDung;
  dynamic maHienTrangSuDung;
  double? dienTich;
  double? tichLuongKho;
  double? tichLuongKhoKiemKe;
  String? namSuDung;
  int? soTang;
  String? bienKiemSoat;
  dynamic nhanHieu;
  int? soChoNgoi;
  dynamic congXuat;
  int? namSanXuat;
  dynamic nuocSanXuat;
  String? nhomTaiSanId;
  dynamic maNhomTaiSan;
  dynamic nhomTaiSan;
  String? diaChi;
  dynamic bienDongId;
  int? loaiTaiSanGoc;
  dynamic tenBienDongTaiSan;
  dynamic loaiBienDong;
  String? tenLoaiBienDong;
  dynamic maBienDongTaiSan;
  dynamic ngayBienDong;
  dynamic maPhanCap;
  bool? taiSanGhiGiam;
  dynamic maChungLoai;
  dynamic hinhThucSuDungChuyenDung;
  dynamic bPSDId;
  dynamic donViId;
  dynamic duAnId;
  bool? pheDuyetQuyetToan;
  dynamic xuLyTaiSan;
  dynamic isChon;
  dynamic isXuLy;
  dynamic trangThaiXuLy;
  dynamic trangThaiKK;
  dynamic ghiChu;
  dynamic pheDuyetPASX;
  dynamic phuongAnSXXL;
  dynamic soKyHieuPD;
  dynamic ngayPheDuyet;
  dynamic tenBPSD;
  dynamic tenDTSD;

  TaiSanInBBKK({
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
    this.bPSDId,
    this.donViId,
    this.duAnId,
    this.pheDuyetQuyetToan,
    this.xuLyTaiSan,
    this.isChon,
    this.isXuLy,
    this.trangThaiXuLy,
    this.trangThaiKK,
    this.ghiChu,
    this.pheDuyetPASX,
    this.phuongAnSXXL,
    this.soKyHieuPD,
    this.ngayPheDuyet,
    this.tenBPSD,
    this.tenDTSD,
  });

  TaiSanInBBKK.fromJson(Map<String, dynamic> json) {
    id = json['Id'] as String?;
    taiSanId = json['TaiSanId'] as String?;
    bienBanId = json['BienBanId'] as String?;
    tenTaiSan = json['TenTaiSan'] as String?;
    maTaiSan = json['MaTaiSan'] as String?;
    maDiaBan = json['MaDiaBan'];
    soLuong = json['SoLuong'] as int?;
    soLuongKiemKe = json['SoLuongKiemKe'] as int?;
    chungLoai = json['ChungLoai'] as String?;
    ngayTinh = json['NgayTinh'];
    daGiam = json['Da_Giam'];
    changeIndex = json['ChangeIndex'];
    maKetQuaXuLy = json['MaKetQuaXuLy'];
    maHinhThucXuLy = json['MaHinhThucXuLy'];
    soQuyetDinh = json['SoQuyetDinh'];
    maTaiSanGhiGiam = json['MaTaiSanGhiGiam'];
    taiSanGhiGiamId = json['TaiSanGhiGiamId'];
    taiSanGhiTangId = json['TaiSanGhiTangId'];
    maTaiSanGhiTang = json['MaTaiSanGhiTang'];
    ngayQuyetDinh = json['NgayQuyetDinh'];
    nguyenGia = json['NguyenGia'] as double?;
    haoMonTrongNam = json['HaoMonTrongNam'] as double?;
    haoMonLuyKe = json['HaoMonLuyKe'] as double?;
    khauHaoTrongNam = json['KhauHaoTrongNam'] as double?;
    khauHaoLuyKe = json['KhauHaoLuyKe'] as double?;
    giaTriConLai = json['GiaTriConLai'] as double?;
    boPhanSuDungId = json['BoPhanSuDungId'];
    doiTuongSuDungId = json['DoiTuongSuDungId'];
    maTinhTrangSuDung = json['MaTinhTrangSuDung'] as String?;
    maHinhThucSuDung = json['MaHinhThucSuDung'];
    maHienTrangSuDung = json['MaHienTrangSuDung'];
    dienTich = json['DienTich'] as double?;
    tichLuongKho = json['TichLuongKho'] as double?;
    tichLuongKhoKiemKe = json['TichLuongKhoKiemKe'] as double?;
    namSuDung = json['NamSuDung'] as String?;
    soTang = json['SoTang'] as int?;
    bienKiemSoat = json['BienKiemSoat'] as String?;
    nhanHieu = json['NhanHieu'];
    soChoNgoi = json['SoChoNgoi'] as int?;
    congXuat = json['CongXuat'];
    namSanXuat = json['NamSanXuat'] as int?;
    nuocSanXuat = json['NuocSanXuat'];
    nhomTaiSanId = json['NhomTaiSanId'] as String?;
    maNhomTaiSan = json['MaNhomTaiSan'];
    nhomTaiSan = json['NhomTaiSan'];
    diaChi = json['DiaChi'] as String?;
    bienDongId = json['BienDongId'];
    loaiTaiSanGoc = json['LoaiTaiSanGoc'] as int?;
    tenBienDongTaiSan = json['TenBienDongTaiSan'];
    loaiBienDong = json['LoaiBienDong'];
    tenLoaiBienDong = json['TenLoaiBienDong'] as String?;
    maBienDongTaiSan = json['MaBienDongTaiSan'];
    ngayBienDong = json['NgayBienDong'];
    maPhanCap = json['MaPhanCap'];
    taiSanGhiGiam = json['TaiSanGhiGiam'] as bool?;
    maChungLoai = json['MaChungLoai'];
    hinhThucSuDungChuyenDung = json['HinhThucSuDungChuyenDung'];
    bPSDId = json['BPSD_Id'];
    donViId = json['DonViId'];
    duAnId = json['DuAnId'];
    pheDuyetQuyetToan = json['PheDuyetQuyetToan'] as bool?;
    xuLyTaiSan = json['XuLyTaiSan'];
    isChon = json['IsChon'];
    isXuLy = json['IsXuLy'];
    trangThaiXuLy = json['TrangThaiXuLy'];
    trangThaiKK = json['TrangThaiKK'];
    ghiChu = json['GhiChu'];
    pheDuyetPASX = json['PheDuyetPASX'];
    phuongAnSXXL = json['PhuongAnSXXL'];
    soKyHieuPD = json['SoKyHieuPD'];
    ngayPheDuyet = json['NgayPheDuyet'];
    tenBPSD = json['TenBPSD'];
    tenDTSD = json['TenDTSD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['Id'] = id;
    json['TaiSanId'] = taiSanId;
    json['BienBanId'] = bienBanId;
    json['TenTaiSan'] = tenTaiSan;
    json['MaTaiSan'] = maTaiSan;
    json['MaDiaBan'] = maDiaBan;
    json['SoLuong'] = soLuong;
    json['SoLuongKiemKe'] = soLuongKiemKe;
    json['ChungLoai'] = chungLoai;
    json['NgayTinh'] = ngayTinh;
    json['Da_Giam'] = daGiam;
    json['ChangeIndex'] = changeIndex;
    json['MaKetQuaXuLy'] = maKetQuaXuLy;
    json['MaHinhThucXuLy'] = maHinhThucXuLy;
    json['SoQuyetDinh'] = soQuyetDinh;
    json['MaTaiSanGhiGiam'] = maTaiSanGhiGiam;
    json['TaiSanGhiGiamId'] = taiSanGhiGiamId;
    json['TaiSanGhiTangId'] = taiSanGhiTangId;
    json['MaTaiSanGhiTang'] = maTaiSanGhiTang;
    json['NgayQuyetDinh'] = ngayQuyetDinh;
    json['NguyenGia'] = nguyenGia;
    json['HaoMonTrongNam'] = haoMonTrongNam;
    json['HaoMonLuyKe'] = haoMonLuyKe;
    json['KhauHaoTrongNam'] = khauHaoTrongNam;
    json['KhauHaoLuyKe'] = khauHaoLuyKe;
    json['GiaTriConLai'] = giaTriConLai;
    json['BoPhanSuDungId'] = boPhanSuDungId;
    json['DoiTuongSuDungId'] = doiTuongSuDungId;
    json['MaTinhTrangSuDung'] = maTinhTrangSuDung;
    json['MaHinhThucSuDung'] = maHinhThucSuDung;
    json['MaHienTrangSuDung'] = maHienTrangSuDung;
    json['DienTich'] = dienTich;
    json['TichLuongKho'] = tichLuongKho;
    json['TichLuongKhoKiemKe'] = tichLuongKhoKiemKe;
    json['NamSuDung'] = namSuDung;
    json['SoTang'] = soTang;
    json['BienKiemSoat'] = bienKiemSoat;
    json['NhanHieu'] = nhanHieu;
    json['SoChoNgoi'] = soChoNgoi;
    json['CongXuat'] = congXuat;
    json['NamSanXuat'] = namSanXuat;
    json['NuocSanXuat'] = nuocSanXuat;
    json['NhomTaiSanId'] = nhomTaiSanId;
    json['MaNhomTaiSan'] = maNhomTaiSan;
    json['NhomTaiSan'] = nhomTaiSan;
    json['DiaChi'] = diaChi;
    json['BienDongId'] = bienDongId;
    json['LoaiTaiSanGoc'] = loaiTaiSanGoc;
    json['TenBienDongTaiSan'] = tenBienDongTaiSan;
    json['LoaiBienDong'] = loaiBienDong;
    json['TenLoaiBienDong'] = tenLoaiBienDong;
    json['MaBienDongTaiSan'] = maBienDongTaiSan;
    json['NgayBienDong'] = ngayBienDong;
    json['MaPhanCap'] = maPhanCap;
    json['TaiSanGhiGiam'] = taiSanGhiGiam;
    json['MaChungLoai'] = maChungLoai;
    json['HinhThucSuDungChuyenDung'] = hinhThucSuDungChuyenDung;
    json['BPSD_Id'] = bPSDId;
    json['DonViId'] = donViId;
    json['DuAnId'] = duAnId;
    json['PheDuyetQuyetToan'] = pheDuyetQuyetToan;
    json['XuLyTaiSan'] = xuLyTaiSan;
    json['IsChon'] = isChon;
    json['IsXuLy'] = isXuLy;
    json['TrangThaiXuLy'] = trangThaiXuLy;
    json['TrangThaiKK'] = trangThaiKK;
    json['GhiChu'] = ghiChu;
    json['PheDuyetPASX'] = pheDuyetPASX;
    json['PhuongAnSXXL'] = phuongAnSXXL;
    json['SoKyHieuPD'] = soKyHieuPD;
    json['NgayPheDuyet'] = ngayPheDuyet;
    json['TenBPSD'] = tenBPSD;
    json['TenDTSD'] = tenDTSD;
    return json;
  }

  TaiSan convertToTaiSan() {
    var ts = new TaiSan();
    ts.id = this.id;
    ts.tsId = this.taiSanId;
    ts.maTS = this.maTaiSan;
    ts.tenTS = this.tenTaiSan;
    ts.maDiaBan = this.maDiaBan?.toString();
    ts.soLuong = this.soLuong;
    ts.soLuongKiemKe = this.soLuongKiemKe;
    ts.chungLoai = this.chungLoai;
    ts.ngayTinh = this.ngayTinh?.toString();
    ts.daGiam = this.daGiam?.toInt();
    ts.changeIndex = this.changeIndex?.toInt();
    ts.maKetQuaXuLy = this.maKetQuaXuLy?.toString();
    ts.maHinhThucXuLy = this.maHinhThucXuLy?.toString();
    ts.nguyenGia = this.nguyenGia;
    ts.haoMonNam = this.haoMonTrongNam?.toInt();
    ts.haoMonLuyKe = this.haoMonLuyKe?.toInt();
    ts.khauHaoNam = this.khauHaoTrongNam?.toInt();
    ts.khauHaoLuyKe = this.khauHaoLuyKe?.toInt();
    ts.giaTriConLai = this.giaTriConLai;
    ts.BPSDTSID = this.boPhanSuDungId?.toString();
    ts.DTSDTSID = this.doiTuongSuDungId?.toString();
    ts.maTinhTrangSuDung = this.maTinhTrangSuDung;
    ts.maHinhThucSuDung = this.maHinhThucSuDung?.toString();
    ts.maHienTrangSuDung = this.maHienTrangSuDung?.toString();
    ts.tongDienTich = this.dienTich?.toInt();
    ts.namSuDung = this.namSuDung;
    ts.soTang = this.soTang;
    ts.bienKiemSoat = this.bienKiemSoat;
    ts.nhanHieu = this.nhanHieu?.toString();
    ts.soChoNgoi = this.soChoNgoi;
    ts.congSuat = this.congXuat?.toString();
    ts.namSanXuat = this.namSanXuat;
    ts.nuocSanXuat = this.nuocSanXuat?.toString();
    ts.nhomTaiSanId = this.nhomTaiSanId;
    ts.diaChiNha = this.diaChi;
    ts.diaChiDat = this.diaChi;
    ts.loaiTaiSanGoc = this.loaiTaiSanGoc;
    ts.loanBienDong = this.loaiBienDong?.toInt();
    ts.ngayBienDong = this.ngayBienDong?.toString();
    ts.pheDuyetQuyetToan = this.pheDuyetQuyetToan;
    ts.donViId = this.donViId?.toString();
    ts.hinhThucSuDungChuyenNhuong = this.hinhThucSuDungChuyenDung?.toString();
    ts.trangThaiKK = this.trangThaiKK?.toInt();
    ts.ghiChu = this.ghiChu?.toString();
    ts.tenBPSDTS = this.tenBPSD;
    ts.tenDTSDTS = this.tenDTSD;

    if (UserService.sharedInstance().listBPSD.any(
          (element) => element.key == this.boPhanSuDungId,
        ))
      ts.tenBPSDTS = UserService.sharedInstance()
          .listBPSD
          .firstWhere((element) => element.key == this.boPhanSuDungId)
          .title;

    return ts;
  }

  /// convert a list dynamic to a list accounts
  static List<TaiSanInBBKK> listFromJson(List<dynamic> list) {
    List<TaiSanInBBKK> rows =
        list.map((i) => TaiSanInBBKK.fromJson(i)).toList();
    return rows;
  }
}
