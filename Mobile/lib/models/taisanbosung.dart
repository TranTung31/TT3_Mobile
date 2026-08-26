import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/models/nhomtaisan.dart';
import 'package:qltstc_kiemke/services/user_service.dart';

class TSBS {
  String? id;
  String? taisanId;
  String? maTaiSan;
  String? ten;
  double? nguyengia;
  double? giaTriConLai;
  BPSD? bophansudung;
  int? soLuongKiemKe;
  int? soLuong;
  String? bophansudungId;
  NhomTS? nhomtaisan;
  String? nhomtaisanId;
  String? bienBanId;
  String? tinhtrangsudung;
  String? maHinhThucXuLy;
  String? maKetQuaXuLy;
  int? trangThaiKK;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["Id"] = id;
    data["TenTaiSan"] = ten;
    data["NguyenGia"] = nguyengia;
    data["GiaTriConLai"] = giaTriConLai;
    data["TaiSanId"] = taisanId;
    data["BoPhanSuDungId"] = bophansudung?.key;
    data["NhomTaiSan"] = nhomtaisan?.title;
    data["NhomTaiSanId"] = nhomtaisan?.key;
    data["MaTinhTrangSuDung"] = tinhtrangsudung;
    data["SoLuong"] = 1;
    data["SoLuongKiemKe"] = soLuongKiemKe ?? 1;
    data["MaKetQuaXuLy"] = maKetQuaXuLy;
    data["BienBanId"] = bienBanId;
    data["MaHinhThucXuLy"] = maHinhThucXuLy;
    data["NgayQuyetDinh"] = null;
    data["MaTaiSan"] = maTaiSan;
    data["TrangThaiKK"] = trangThaiKK;
    return data;
  }

  TSBS.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    ten = json["TenTaiSan"];
    bophansudungId = json["BoPhanSuDungId"];
    if (bophansudung == null && bophansudungId != null) {
      if (UserService.sharedInstance().listBPSD.any(
            (element) => element.key == bophansudungId,
          ))
        bophansudung = UserService.sharedInstance().listBPSD.firstWhere(
              (element) => element.key == bophansudungId,
            );
    }
    nguyengia = json["NguyenGia"] as double;
    giaTriConLai = json["GiaTriConLai"] as double;
    nhomtaisanId = json["NhomTaiSanId"];
    if (nhomtaisan == null && nhomtaisanId != null) {
      if (UserService.sharedInstance().listNhomTS.any(
            (element) => element.key == nhomtaisanId,
          ))
        nhomtaisan = UserService.sharedInstance().listNhomTS.firstWhere(
              (element) => element.key == nhomtaisanId,
            );
    }
    tinhtrangsudung = json["MaTinhTrangSuDung"];
    soLuong = json["SoLuong"];
    soLuongKiemKe = json["SoLuongKiemKe"];
    maHinhThucXuLy = json["MaHinhThucXuLy"];
    maKetQuaXuLy = json["MaKetQuaXuLy"];
    taisanId = json["TaiSanId"];
    maTaiSan = json["MaTaiSan"];
    bienBanId = json["BienBanId"];
    trangThaiKK = json["TrangThaiKK"];
  }

  TSBS();

  static List<TSBS> listFromJson(List<dynamic> list) {
    List<TSBS> rows = list.map((i) => TSBS.fromJson(i)).toList();
    return rows;
  }
}
