class UserInfo {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? refreshToken;
  String? asClientId;
  String? userName;
  String? curentUserId;
  String? roles;
  String? privileges;
  String? donviId;
  String? loaiHinhDonVi;
  String? maDonVi;
  String? tenDonVi;
  String? cheDoHachToan;
  String? startDate;
  String? endDate;
  String? cheDoNhapLieu;
  String? dongBoKhoaSo;
  String? laDonViNhapLieu;
  String? laDonViChaCap1;
  String? avatar;
  String? duyetTaiSan;
  String? nguyenGiaToiThieuTaiSan;
  String? ngaychotsodu;
  String? ngaychotsodutoanhethong;
  String? maxsaochep;
  String? nguyenGiaToiThieuHeThong;
  String? maDiaBan;
  String? namKhoaSo;
  String? isDonViTuChu;
  String? maHeThong;
  String? totalThongBao;
  String? tenDonViCha;
  String? trangThaiTruocKhiDangNhap;
  String? capDonvi;
  String? laDonViMSTT;
  String? checkKhoaSo;
  String? ngayKhoaSo;
  String? issued;
  String? expires;
  String? message;

  UserInfo(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.refreshToken,
      this.asClientId,
      this.userName,
      this.roles,
      this.privileges,
      this.donviId,
      this.loaiHinhDonVi,
      this.maDonVi,
      this.tenDonVi,
      this.cheDoHachToan,
      this.startDate,
      this.endDate,
      this.cheDoNhapLieu,
      this.dongBoKhoaSo,
      this.laDonViNhapLieu,
      this.laDonViChaCap1,
      this.avatar,
      this.duyetTaiSan,
      this.nguyenGiaToiThieuTaiSan,
      this.ngaychotsodu,
      this.ngaychotsodutoanhethong,
      this.maxsaochep,
      this.nguyenGiaToiThieuHeThong,
      this.maDiaBan,
      this.namKhoaSo,
      this.isDonViTuChu,
      this.maHeThong,
      this.totalThongBao,
      this.tenDonViCha,
      this.trangThaiTruocKhiDangNhap,
      this.capDonvi,
      this.laDonViMSTT,
      this.checkKhoaSo,
      this.ngayKhoaSo,
      this.issued,
      this.expires,
      this.message});

  UserInfo.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    asClientId = json['as:client_id'];
    userName = json['userName'];
    curentUserId = json['curentUserId'];
    roles = json['roles'];
    privileges = json['privileges'];
    donviId = json['donviId'];
    loaiHinhDonVi = json['loaiHinhDonVi'];
    maDonVi = json['maDonVi'];
    tenDonVi = json['tenDonVi'];
    cheDoHachToan = json['cheDoHachToan'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    cheDoNhapLieu = json['cheDoNhapLieu'];
    dongBoKhoaSo = json['dongBoKhoaSo'];
    laDonViNhapLieu = json['laDonViNhapLieu'];
    laDonViChaCap1 = json['laDonViChaCap1'];
    avatar = json['avatar'];
    duyetTaiSan = json['duyetTaiSan'];
    nguyenGiaToiThieuTaiSan = json['nguyenGiaToiThieuTaiSan'];
    ngaychotsodu = json['ngaychotsodu'];
    ngaychotsodutoanhethong = json['ngaychotsodutoanhethong'];
    maxsaochep = json['maxsaochep'];
    nguyenGiaToiThieuHeThong = json['nguyenGiaToiThieuHeThong'];
    maDiaBan = json['maDiaBan'];
    namKhoaSo = json['namKhoaSo'];
    isDonViTuChu = json['isDonViTuChu'];
    maHeThong = json['maHeThong'];
    totalThongBao = json['totalThongBao'];
    tenDonViCha = json['tenDonViCha'];
    trangThaiTruocKhiDangNhap = json['trangThaiTruocKhiDangNhap'];
    capDonvi = json['capDonvi'];
    laDonViMSTT = json['laDonViMSTT'];
    checkKhoaSo = json['checkKhoaSo'];
    ngayKhoaSo = json['ngayKhoaSo'];
    issued = json['.issued'];
    expires = json['.expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['refresh_token'] = this.refreshToken;
    data['as:client_id'] = this.asClientId;
    data['userName'] = this.userName;
    data['roles'] = this.roles;
    data['privileges'] = this.privileges;
    data['donviId'] = this.donviId;
    data['loaiHinhDonVi'] = this.loaiHinhDonVi;
    data['maDonVi'] = this.maDonVi;
    data['tenDonVi'] = this.tenDonVi;
    data['cheDoHachToan'] = this.cheDoHachToan;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['cheDoNhapLieu'] = this.cheDoNhapLieu;
    data['dongBoKhoaSo'] = this.dongBoKhoaSo;
    data['laDonViNhapLieu'] = this.laDonViNhapLieu;
    data['laDonViChaCap1'] = this.laDonViChaCap1;
    data['avatar'] = this.avatar;
    data['duyetTaiSan'] = this.duyetTaiSan;
    data['nguyenGiaToiThieuTaiSan'] = this.nguyenGiaToiThieuTaiSan;
    data['ngaychotsodu'] = this.ngaychotsodu;
    data['ngaychotsodutoanhethong'] = this.ngaychotsodutoanhethong;
    data['maxsaochep'] = this.maxsaochep;
    data['nguyenGiaToiThieuHeThong'] = this.nguyenGiaToiThieuHeThong;
    data['maDiaBan'] = this.maDiaBan;
    data['namKhoaSo'] = this.namKhoaSo;
    data['isDonViTuChu'] = this.isDonViTuChu;
    data['maHeThong'] = this.maHeThong;
    data['totalThongBao'] = this.totalThongBao;
    data['tenDonViCha'] = this.tenDonViCha;
    data['trangThaiTruocKhiDangNhap'] = this.trangThaiTruocKhiDangNhap;
    data['capDonvi'] = this.capDonvi;
    data['laDonViMSTT'] = this.laDonViMSTT;
    data['checkKhoaSo'] = this.checkKhoaSo;
    data['ngayKhoaSo'] = this.ngayKhoaSo;
    data['.issued'] = this.issued;
    data['.expires'] = this.expires;
    return data;
  }
}
