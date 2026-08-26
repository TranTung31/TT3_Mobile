import 'package:qltstc_kiemke/models/taisanbosung.dart';
import 'package:qltstc_kiemke/services/user_service.dart';

class TaiSan {
  /*
{
  "MA_TAI_SAN": "000000523",
  "TEN_TAI_SAN": "xe máy, mô tô",
  "TEN_DTSDTS": null,
  "TEN_NHOM_TAI_SAN": null,
  "NGAY_SU_DUNG": "2020-10-31T00:00:00",
  "NGAY_BIEN_DONG": null,
  "NAM_SAN_XUAT": 2019,
  "NUOC_SAN_XUAT": null,
  "THONG_SO_KT": null,
  "NGUYEN_GIA": null,
  "CONG_SUAT": null,
  "QRCODE": null,
  "NGUYEN_GIA_BANG_CHU": "",
  "NAM_SU_DUNG": "2020",
  "TAI_SAN_ID": "d6cb468f-b78d-415c-a4f1-8282e3147c12",
  "LOAI_TAI_SAN_GOC": 5,
  "CHANGE_INDEX": 1,
  "DA_GIAM": 0,
  "NGAY_TINH": "2021-10-31T00:00:00",
  "SO_LUONG": 1,
  "KHOI_LUONG_SO_LUONG": 0,
  "HAO_MON_NAM": 0,
  "HAO_MON_LUY_KE": 2000000,
  "KHAU_HAO_NAM": 0,
  "MA_DIA_BAN": null,
  "KHAU_HAO_LUY_KE": 0,
  "GIA_TRI_CON_LAI": 18000000,
  "BPSDTS_ID": null,
  "DTSDTS_ID": null,
  "MA_TINH_TRANG_SU_DUNG": null,
  "MA_HINH_THUC_SU_DUNG": null,
  "MA_HIEN_TRANG_SU_DUNG": null,
  "PHE_DUYET_QUYET_TOAN": false,
  "TONG_DIEN_TICH": 0,
  "SO_TANG": 0,
  "BIEN_KIEM_SOAT": "29a-918.29",
  "NHAN_HIEU": null,
  "SO_CHO_NGOI": 2,
  "DON_VI_ID": "351c7441-6c73-46ca-afb7-be9b1aac525f",
  "NHOM_TAI_SAN_ID": "c61b4185-ebc3-41d9-b60a-8b87598dac59",
  "LOAI_BIEN_DONG": 1,
  "CHUNG_LOAI": null,
  "DIA_CHI_NHA": "",
  "DIA_CHI_DAT": "",
  "HINH_THUC_SU_DUNG_CHUYEN_DUNG": null
}
*/

  String? id;
  String? maTS;
  String? tenTS;
  String? tenDTSDTS;
  String? tenBPSDTS;
  // String? tenNguoiSuDung;
  String? tenNhomTS;
  String? ngaySuDung;
  String? ngayBienDong;
  int? namSanXuat;
  String? nuocSanXuat;
  String? thongSoKyThuat;
  double? nguyenGia;
  double? nguyenGiaGoc;
  String? congSuat;
  String? qrCode;
  String? nguyenGiaText;
  String? namSuDung;
  String? tsId;
  int? loaiTaiSanGoc;
  int? changeIndex;
  int? daGiam;
  String? lyDoTang;
  String? liDoGiam;
  String? ngayTinh;
  int? soLuong;
  int? soLuongKiemKe;
  int? khoiLuongSoLuong;
  int? haoMonNam;
  int? haoMonLuyKe;
  int? khauHaoNam;
  String? maDiaBan;
  int? khauHaoLuyKe;
  double? giaTriConLai;
  String? BPSDTSID;
  String? DTSDTSID;
  String? tinhTrangSuDung;
  String? maTinhTrangSuDung;
  String? maHinhThucSuDung;
  String? maHienTrangSuDung;
  String? maKetQuaXuLy;
  bool? pheDuyetQuyetToan;
  int? tongDienTich;
  int? soTang;
  String? bienKiemSoat;
  String? nhanHieu;
  int? soChoNgoi;
  String? donViId;
  String? nhomTaiSanId;
  int? loanBienDong;
  String? chungLoai;
  String? diaChiNha;
  String? diaChiDat;
  String? hinhThucSuDungChuyenNhuong;
  String? maHinhThucXuLy;
  String? ghiChu;
  int? trangThaiKK;
  late bool hasScanned;
  TaiSan({
    this.maTS,
    this.tenTS,
    this.tenDTSDTS,
    this.tenBPSDTS,
    this.tenNhomTS,
    this.ngaySuDung,
    this.ngayBienDong,
    this.namSanXuat,
    this.nuocSanXuat,
    this.thongSoKyThuat,
    this.nguyenGia,
    this.nguyenGiaGoc,
    this.congSuat,
    this.qrCode,
    this.nguyenGiaText,
    this.namSuDung,
    this.tsId,
    this.loaiTaiSanGoc,
    this.changeIndex,
    this.daGiam,
    this.lyDoTang,
    this.ngayTinh,
    this.soLuong,
    this.khoiLuongSoLuong,
    this.haoMonNam,
    this.haoMonLuyKe,
    this.khauHaoNam,
    this.maDiaBan,
    this.khauHaoLuyKe,
    this.giaTriConLai,
    this.BPSDTSID,
    this.DTSDTSID,
    this.tinhTrangSuDung,
    this.maTinhTrangSuDung,
    this.maHinhThucSuDung,
    this.maHienTrangSuDung,
    this.maKetQuaXuLy,
    this.pheDuyetQuyetToan,
    this.tongDienTich,
    this.soTang,
    this.bienKiemSoat,
    this.nhanHieu,
    this.soChoNgoi,
    this.donViId,
    this.nhomTaiSanId,
    this.loanBienDong,
    this.chungLoai,
    this.diaChiNha,
    this.diaChiDat,
    this.hinhThucSuDungChuyenNhuong,
    this.maHinhThucXuLy,
    this.trangThaiKK,
    this.ghiChu,
    this.hasScanned = false,
  });

  TaiSan.fromJson(Map<String, dynamic> json) {
    maTS = json['MA_TAI_SAN']?.toString();
    tenTS = json['TEN_TAI_SAN']?.toString();
    tenDTSDTS = json['TEN_DTSDTS']?.toString();
    tenBPSDTS = json['TEN_BPSDTS']?.toString();
    tenNhomTS = json['TEN_NHOM_TAI_SAN']?.toString();
    ngaySuDung = json['NGAY_SU_DUNG']?.toString();
    ngayBienDong = json['NGAY_BIEN_DONG']?.toString();
    namSanXuat = json['NAM_SAN_XUAT']?.toInt();
    nuocSanXuat = json['NUOC_SAN_XUAT']?.toString();
    thongSoKyThuat = json['THONG_SO_KT']?.toString();
    nguyenGia = json['NGUYEN_GIA'] != null
        ? double.parse(json['NGUYEN_GIA'].toString())
        : 0;
    nguyenGiaGoc = json['NGUYEN_GIA_GOC'] != null
        ? double.parse(json['NGUYEN_GIA_GOC'].toString())
        : 0;
    congSuat = json['CONG_SUAT']?.toString();
    qrCode = json['QRCODE']?.toString();
    nguyenGiaText = json['NGUYEN_GIA_BANG_CHU']?.toString();
    namSuDung = json['NAM_SU_DUNG']?.toString();
    tsId = json['TAI_SAN_ID']?.toString();
    loaiTaiSanGoc = json['LOAI_TAI_SAN_GOC']?.toInt();
    changeIndex = json['CHANGE_INDEX']?.toInt();
    daGiam = json['DA_GIAM']?.toInt();
    liDoGiam = json['LY_DO_GIAM_TS']?.toString();
    lyDoTang = json['LY_DO_TANG']?.toString();
    ngayTinh = json['NGAY_TINH']?.toString();
    soLuong = json['SO_LUONG']?.toInt();
    soLuongKiemKe = json['SO_LUONG_KIEM_KE']?.toInt();
    // soLuongKiemKe = null;
    khoiLuongSoLuong = json['KHOI_LUONG_SO_LUONG']?.toInt();
    haoMonNam = json['HAO_MON_NAM']?.toInt();
    haoMonLuyKe = json['HAO_MON_LUY_KE']?.toInt();
    khauHaoNam = json['KHAU_HAO_NAM']?.toInt();
    maDiaBan = json['MA_DIA_BAN']?.toString();
    khauHaoLuyKe = json['KHAU_HAO_LUY_KE']?.toInt();
    giaTriConLai = json['GIA_TRI_CON_LAI']?.toDouble();
    BPSDTSID = json['BPSDTS_ID']?.toString();
    DTSDTSID = json['DTSDTS_ID']?.toString();
    tinhTrangSuDung = json['TINH_TRANG_SD']?.toString();
    maTinhTrangSuDung = json['MA_TINH_TRANG_SU_DUNG']?.toString();
    maHinhThucSuDung = json['MA_HINH_THUC_SU_DUNG']?.toString();
    maHienTrangSuDung = json['MA_HIEN_TRANG_SU_DUNG']?.toString();
    maKetQuaXuLy = json['MA_KET_QUA_XU_LY']?.toString();
    pheDuyetQuyetToan = json['PHE_DUYET_QUYET_TOAN'];
    tongDienTich = json['TONG_DIEN_TICH']?.toInt();
    soTang = json['SO_TANG']?.toInt();
    bienKiemSoat = json['BIEN_KIEM_SOAT']?.toString();
    nhanHieu = json['NHAN_HIEU']?.toString();
    soChoNgoi = json['SO_CHO_NGOI']?.toInt();
    donViId = json['DON_VI_ID']?.toString();
    nhomTaiSanId = json['NHOM_TAI_SAN_ID']?.toString();
    loanBienDong = json['LOAI_BIEN_DONG']?.toInt();
    chungLoai = json['CHUNG_LOAI']?.toString();
    diaChiNha = json['DIA_CHI_NHA']?.toString();
    diaChiDat = json['DIA_CHI_DAT']?.toString();
    hinhThucSuDungChuyenNhuong =
        json['HINH_THUC_SU_DUNG_CHUYEN_DUNG']?.toString();
    if (tenBPSDTS == null && BPSDTSID != null) {
      if (UserService.sharedInstance().listBPSD.any(
            (element) => element.key == BPSDTSID,
          ))
        tenBPSDTS = UserService.sharedInstance()
            .listBPSD
            .firstWhere((element) => element.key == BPSDTSID)
            .title;
      if (tenDTSDTS == null && DTSDTSID != null) {
        UserService.sharedInstance().getNSD(BPSDTSID!).then((value) {
          if (value.length > 0) {
            tenDTSDTS = value
                .firstWhere((element) => element.dtsdtsId == DTSDTSID)
                .tenDTSDTS;
          }
        });
      }
    }

    trangThaiKK = json['TRANG_THAI_KK']?.toInt();
    ghiChu = json['GHI_CHU']?.toString();
    hasScanned = false;
  }

  /// convert a list dynamic to a list accounts
  static List<TaiSan> listFromJson(List<dynamic> list) {
    List<TaiSan> rows = list.map((i) => TaiSan.fromJson(i)).toList();
    return rows;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['MA_TAI_SAN'] = maTS;
    data['TEN_TAI_SAN'] = tenTS;
    data['TEN_DTSDTS'] = tenDTSDTS;
    data['TEN_BPSDTS'] = tenBPSDTS;
    data['TEN_NHOM_TAI_SAN'] = tenNhomTS;
    data['NGAY_SU_DUNG'] = ngaySuDung;
    data['NGAY_BIEN_DONG'] = ngayBienDong;
    data['NAM_SAN_XUAT'] = namSanXuat;
    data['NUOC_SAN_XUAT'] = nuocSanXuat;
    data['THONG_SO_KT'] = thongSoKyThuat;
    data['NGUYEN_GIA'] = nguyenGia;
    data['NGUYEN_GIA_GOC'] = nguyenGiaGoc;
    data['CONG_SUAT'] = congSuat;
    data['QRCODE'] = qrCode;
    data['NGUYEN_GIA_BANG_CHU'] = nguyenGiaText;
    data['NAM_SU_DUNG'] = namSuDung;
    data['TAI_SAN_ID'] = tsId;
    data['LOAI_TAI_SAN_GOC'] = loaiTaiSanGoc;
    data['CHANGE_INDEX'] = changeIndex;
    data['DA_GIAM'] = daGiam;
    data['LY_DO_TANG'] = lyDoTang;
    data['NGAY_TINH'] = ngayTinh;
    data['SO_LUONG'] = soLuong;
    data['SO_LUONG_KIEM_KE'] = soLuongKiemKe;
    data['KHOI_LUONG_SO_LUONG'] = khoiLuongSoLuong;
    data['HAO_MON_NAM'] = haoMonNam;
    data['HAO_MON_LUY_KE'] = haoMonLuyKe;
    data['KHAU_HAO_NAM'] = khauHaoNam;
    data['MA_DIA_BAN'] = maDiaBan;
    data['KHAU_HAO_LUY_KE'] = khauHaoLuyKe;
    data['GIA_TRI_CON_LAI'] = giaTriConLai;
    data['BPSDTS_ID'] = BPSDTSID;
    data['DTSDTS_ID'] = DTSDTSID;
    data['MA_TINH_TRANG_SU_DUNG'] = maTinhTrangSuDung;
    data['MA_HINH_THUC_SU_DUNG'] = maHinhThucSuDung;
    data['MA_HIEN_TRANG_SU_DUNG'] = maHienTrangSuDung;
    data['PHE_DUYET_QUYET_TOAN'] = pheDuyetQuyetToan;
    data['MA_KET_QUA_XU_LY'] = maKetQuaXuLy;
    data['TONG_DIEN_TICH'] = tongDienTich;
    data['SO_TANG'] = soTang;
    data['BIEN_KIEM_SOAT'] = bienKiemSoat;
    data['NHAN_HIEU'] = nhanHieu;
    data['SO_CHO_NGOI'] = soChoNgoi;
    data['DON_VI_ID'] = donViId;
    data['NHOM_TAI_SAN_ID'] = nhomTaiSanId;
    data['LOAI_BIEN_DONG'] = loanBienDong;
    data['CHUNG_LOAI'] = chungLoai;
    data['DIA_CHI_NHA'] = diaChiNha;
    data['DIA_CHI_DAT'] = diaChiDat;
    data['HINH_THUC_SU_DUNG_CHUYEN_DUNG'] = hinhThucSuDungChuyenNhuong;
    data['TRANG_THAI_KK'] = trangThaiKK;
    data['GHI_CHU'] = ghiChu;
    return data;
  }

  TSBS convertToTSBS() {
    TSBS tsbs = new TSBS();
    tsbs.id = this.id;
    tsbs.taisanId = this.tsId;
    tsbs.maTaiSan = this.maTS;
    tsbs.maHinhThucXuLy = this.maHinhThucXuLy;
    tsbs.soLuongKiemKe = 0;
    tsbs.soLuong = this.soLuong ?? 1;
    tsbs.nguyengia = this.nguyenGia ?? 0;
    tsbs.giaTriConLai = this.giaTriConLai ?? 0;
    tsbs.ten = this.tenTS;
    tsbs.bophansudungId = this.BPSDTSID;
    if (tsbs.bophansudungId != null) {
      if (UserService.sharedInstance().listBPSD.any(
            (element) => element.key == tsbs.bophansudungId,
          ))
        tsbs.bophansudung = UserService.sharedInstance()
            .listBPSD
            .firstWhere((element) => element.key == tsbs.bophansudungId);
    }
    tsbs.nhomtaisanId = this.nhomTaiSanId;
    if (tsbs.nhomtaisanId != null) {
      if (UserService.sharedInstance().listNhomTS.any(
            (element) => element.key == tsbs.nhomtaisanId,
          ))
        tsbs.nhomtaisan = UserService.sharedInstance()
            .listNhomTS
            .firstWhere((element) => element.key == tsbs.nhomtaisanId);
    }
    tsbs.tinhtrangsudung = this.tinhTrangSuDung;
    // tsbs.bienBanId = this.;
    tsbs.maHinhThucXuLy = this.maHinhThucXuLy;
    tsbs.maKetQuaXuLy = this.maKetQuaXuLy;
    tsbs.trangThaiKK = this.trangThaiKK;

    return tsbs;
  }
}
