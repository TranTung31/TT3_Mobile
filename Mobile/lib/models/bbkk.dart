import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/models/taisan.dart';
import 'package:qltstc_kiemke/models/taisan_in_bbkk.dart';
import 'package:qltstc_kiemke/models/taisanbosung.dart';
import 'package:qltstc_kiemke/models/thanhvienhoidong.dart';
import 'package:qltstc_kiemke/services/user_service.dart';

class BBKK {
  String? Id;
  String? SoBienBan;
  String? TenDotKiemKe;
  String? NgayLap;
  String? NgayKiemKe;
  String? DonViId;
  String? NhomTaiSanId;
  String? NhomCongCuId;
  String? BoPhanSuDung;
  String? BoPhanKiemKeId;
  String? DTSDTS_Id;
  String? DuAnId;
  String? BPSDTS_Id;
  String? ApDung;
  String? DienGiai;
  String? HinhThucKiemKe;
  String? NguyenNhanThuaThieu;
  String? KienNghiDeXuat;
  int? TrangThai;
  List<TVHD>? ThanhVienHoiDong;
  List<TSBS>? ListTaiSanTamThoi;
  List<TaiSanInBBKK>? ListTaiSanInBBKK;
  List<TaiSan>? ListTaiSan;
  List<String>? LstTaiSanId;
  int? LaLuuNhap;
  String? TenBPSDTS;
  String? TenTrangThai;
  bool hasUpdated = false;
  bool hasLoadedAssets = false;
  BBKK();

  Map<String, dynamic> toJson() {
    var currentUser = UserService.sharedInstance().currentUser!;
    final Map<String, dynamic> data = Map<String, dynamic>();
    var df1 = DateFormat("dd/MM/yyyy");
    var df2 = DateFormat("yyyy/MM/dd");
    data["Id"] = Id;
    data["SoBienBan"] = SoBienBan;
    data["TenDotKiemKe"] = TenDotKiemKe;
    data["NgayLap"] = df2.format(df1.parse(NgayLap!));
    data["NgayKiemKe"] = df2.format(df1.parse(NgayKiemKe!));
    data["DonViId"] = DonViId;
    data["NhomTaiSanId"] = NhomTaiSanId;
    data["NhomCongCuId"] = NhomCongCuId;
    data["BoPhanSuDungId"] = BoPhanKiemKeId;
    data["DTSDTS_Id"] = DTSDTS_Id;
    data["DuAnId"] = DuAnId;
    data["BPSDTS_Id"] = BPSDTS_Id;
    data["ApDung"] = ApDung;
    data["DienGiai"] = DienGiai;
    data["HinhThucKiemKe"] = _getCodeHTKK(HinhThucKiemKe);
    data["NguyenNhanThuaThieu"] = NguyenNhanThuaThieu;
    data["KienNghiDeXuat"] = KienNghiDeXuat;
    data["userName"] = currentUser.userName;
    data["curentUserId"] = currentUser.curentUserId;
    data["TrangThai"] = TrangThai;
    data["LaLuuNhap"] = LaLuuNhap;
    if (ThanhVienHoiDong != null)
      data["ThanhVienHoiDong"] =
          ThanhVienHoiDong!.map((e) => e.toJson()).toList();
    if (ListTaiSanTamThoi != null)
      data["ListTaiSanTamThoi"] =
          ListTaiSanTamThoi!.map((e) => e.toJson()).toList();
    if (ListTaiSan != null && ListTaiSan!.length > 0) {
      LstTaiSanId = [];

      ListTaiSan!.forEach((element) {
        if (element.trangThaiKK == 1) {
          LstTaiSanId!.add(element.tsId!);
        }
      });
      if (LstTaiSanId != null) data["LstTaiSanId"] = LstTaiSanId;
    }
    data['hasUpdated'] = this.hasUpdated;
    data['hasLoadedAssets'] = this.hasLoadedAssets;
    return data;
  }

  BBKK.fromJson(Map<String, dynamic> json) {
    DateFormat df = new DateFormat("dd/MM/yyyy");
    Id = json['Id'];
    SoBienBan = json['SoBienBan'];
    TenDotKiemKe = json['TenDotKiemKe'];
    if (json['NgayKiemKe'] != null) {
      NgayKiemKe = df.format(DateTime.parse(json['NgayKiemKe']));
    }
    BoPhanSuDung = json['BoPhanSuDung'] ?? json['BoPhanKiemKe'];
    BoPhanKiemKeId = json['BoPhanKiemKeId'];
    if (json['NgayLap'] != null) {
      NgayLap = df.format(DateTime.parse(json['NgayLap']));
    }
    // BPSDTS = json['MaBPSDTS'];
    BPSDTS_Id = json['BPSDTS_Id'];
    TenBPSDTS = json['TenBPSDTS'];
    HinhThucKiemKe = _getTextHTKK(json['HinhThucKiemKe']);
    ApDung = json['ApDung'];
    TrangThai = json['TrangThai'] != null
        ? double.parse(json['TrangThai'].toString()).round()
        : 0;
    TenTrangThai = json['TenTrangThai'];
    DonViId = json['DonViId'];
    NhomCongCuId = json['NhomCongCuId'];
    // ListNhomCongCu = json['ListNhomCongCu'];
    ListTaiSanInBBKK = (json['TaiSan'] == null)
        ? []
        : TaiSanInBBKK.listFromJson(json['TaiSan']);
    // cCDC = json['CCDC'];
    // congCuKiemKeDetail = json['CongCuKiemKeDetail'];
    // listCCKKTamThoi = json['ListCCKKTamThoi'];
    // congCuKiemKeDetailThieu = json['CongCuKiemKeDetailThieu'];
    ThanhVienHoiDong = (json['ThanhVienHoiDong'] == null)
        ? []
        : TVHD.listFromJson(json['ThanhVienHoiDong']);
    ListTaiSanTamThoi = (json['TaiSanThieu'] == null)
        ? []
        : TSBS.listFromJson(json['TaiSanThieu']);
    // thuTruongDonVi = json['ThuTruongDonVi'];
    // truongPhongHanhChinh = json['TruongPhongHanhChinh'];
    // truongPhongKeToan = json['TruongPhongKeToan'];
    // checkNamKhoaSo = json['CheckNamKhoaSo'];
    // kiemSoatVien = json['KiemSoatVien'];
    // chuTichHoiDong = json['ChuTichHoiDong'];
    LaLuuNhap = json['LaLuuNhap'];
    // bienDongCC = json['BienDongCC'];
    hasUpdated = json['hasUpdated'] ?? false;
    hasLoadedAssets = json['hasLoadedAssets'] ?? false;
  }

  /// convert a list dynamic to a list accounts
  static List<BBKK> listFromJson(List<dynamic> list) {
    List<BBKK> rows = list.map((i) => BBKK.fromJson(i)).toList();
    return rows;
  }

  int _getCodeHTKK(String? htkkString) {
    switch (htkkString) {
      case "Kiểm kê thường niên":
        return 1;
      case "Kiểm kê đột xuất":
        return 2;
      case "Kiểm kê khác":
        return 3;
      case "Kiểm kê tài sản dự án":
        return 4;
      default:
        return 1;
    }
  }

  String _getTextHTKK(int? htkkString) {
    switch (htkkString) {
      case 1:
        return "Kiểm kê thường niên";
      case 2:
        return "Kiểm kê đột xuất";
      case 3:
        return "Kiểm kê khác";
      case 4:
        return "Kiểm kê tài sản dự án";
      default:
        return "Kiểm kê thường niên";
    }
  }
}
