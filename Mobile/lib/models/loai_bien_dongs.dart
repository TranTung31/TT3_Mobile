import 'package:qltstc_kiemke/models/taisan.dart';

class LoaiBienDongs {
  String? maTaiSan;
  String? tenTaiSan;
  String? tenDTSDTS;
  String? tenBPSDTS;
  String? tenNhomTaiSan;
  String? ngaySuDung;
  String? ngayBienDong;
  int? namSanXuat;
  String? nuocSanXuat;
  String? thongSoKT;
  double? nguyenGia;
  double? nguyenGiaGoc;
  String? congSuat;
  String? qrCode;
  String? nguyenGiaBangChu;
  String? namSuDung;
  String? taiSanIdDraf;
  String? taiSanId;
  int? loaiTaiSanGoc;
  int? changeIndex;
  int? daGiam;
  String? ngayTinh;
  double? soLuong;
  double? khoiLuongSoLuong;
  double? haoMonNam;
  double? haoMonLuyKe;
  double? khauHaoNam;
  String? maDiaBan;
  double? khauHaoLuyKe;
  double? giaTriConLai;
  String? bpsdtsId;
  String? dtsdtsId;
  String? bpsdtsIdDraf;
  String? dtsdtsIdDraf;
  String? maTinhTrangSuDung;
  String? maHinhThucSuDung;
  String? maHienTrangSuDung;
  bool? pheDuyetQuyetToan;
  double? tongDienTich;
  int? soTang;
  String? bienKiemSoat;
  String? nhanHieu;
  int? soChoNgoi;
  String? donViId;
  String? nhomTaiSanId;
  String? donViIdDraf;
  String? nhomTaiSanIdDraf;
  double? loaiBienDong;
  String? chungLoai;
  String? diaChiNha;
  String? diaChiDat;
  String? hinhThucSuDungChuyenDung;
  String? lyDoGiamTS;
  String? lyDoTang;
  int? pheDuyetQuyetToanDraf;
  String? nguoiSuDung;
  List<LoaiBienDongItem>? loaiBienDongs;

  LoaiBienDongs({
    this.maTaiSan,
    this.tenTaiSan,
    this.tenDTSDTS,
    this.tenBPSDTS,
    this.tenNhomTaiSan,
    this.ngaySuDung,
    this.ngayBienDong,
    this.namSanXuat,
    this.nuocSanXuat,
    this.thongSoKT,
    this.nguyenGia,
    this.nguyenGiaGoc,
    this.congSuat,
    this.qrCode,
    this.nguyenGiaBangChu,
    this.namSuDung,
    this.taiSanIdDraf,
    this.taiSanId,
    this.loaiTaiSanGoc,
    this.changeIndex,
    this.daGiam,
    this.ngayTinh,
    this.soLuong,
    this.khoiLuongSoLuong,
    this.haoMonNam,
    this.haoMonLuyKe,
    this.khauHaoNam,
    this.maDiaBan,
    this.khauHaoLuyKe,
    this.giaTriConLai,
    this.bpsdtsId,
    this.dtsdtsId,
    this.bpsdtsIdDraf,
    this.dtsdtsIdDraf,
    this.maTinhTrangSuDung,
    this.maHinhThucSuDung,
    this.maHienTrangSuDung,
    this.pheDuyetQuyetToan,
    this.tongDienTich,
    this.soTang,
    this.bienKiemSoat,
    this.nhanHieu,
    this.soChoNgoi,
    this.donViId,
    this.nhomTaiSanId,
    this.donViIdDraf,
    this.nhomTaiSanIdDraf,
    this.loaiBienDong,
    this.chungLoai,
    this.diaChiNha,
    this.diaChiDat,
    this.hinhThucSuDungChuyenDung,
    this.lyDoGiamTS,
    this.lyDoTang,
    this.pheDuyetQuyetToanDraf,
    this.nguoiSuDung,
    this.loaiBienDongs,
  });

  LoaiBienDongs.fromJson(Map<String, dynamic> json) {
    maTaiSan = json['MA_TAI_SAN']?.toString();
    tenTaiSan = json['TEN_TAI_SAN']?.toString();
    tenDTSDTS = json['TEN_DTSDTS']?.toString();
    tenBPSDTS = json['TEN_BPSDTS']?.toString();
    tenNhomTaiSan = json['TEN_NHOM_TAI_SAN']?.toString();
    ngaySuDung = json['NGAY_SU_DUNG']?.toString();
    ngayBienDong = json['NGAY_BIEN_DONG']?.toString();
    namSanXuat = json['NAM_SAN_XUAT']?.toInt();
    nuocSanXuat = json['NUOC_SAN_XUAT']?.toString();
    thongSoKT = json['THONG_SO_KT']?.toString();
    nguyenGia = json['NGUYEN_GIA']?.toDouble();
    nguyenGiaGoc = json['NGUYEN_GIA_GOC']?.toDouble();
    congSuat = json['CONG_SUAT']?.toString();
    qrCode = json['QRCODE']?.toString();
    nguyenGiaBangChu = json['NGUYEN_GIA_BANG_CHU']?.toString();
    namSuDung = json['NAM_SU_DUNG']?.toString();
    taiSanIdDraf = json['TAI_SAN_ID_DRAF']?.toString();
    taiSanId = json['TAI_SAN_ID']?.toString();
    loaiTaiSanGoc = json['LOAI_TAI_SAN_GOC']?.toInt();
    changeIndex = json['CHANGE_INDEX']?.toInt();
    daGiam = json['DA_GIAM']?.toInt();
    ngayTinh = json['NGAY_TINH']?.toString();
    soLuong = json['SO_LUONG']?.toDouble();
    khoiLuongSoLuong = json['KHOI_LUONG_SO_LUONG']?.toDouble();
    haoMonNam = json['HAO_MON_NAM']?.toDouble();
    haoMonLuyKe = json['HAO_MON_LUY_KE']?.toDouble();
    khauHaoNam = json['KHAU_HAO_NAM']?.toDouble();
    maDiaBan = json['MA_DIA_BAN']?.toString();
    khauHaoLuyKe = json['KHAU_HAO_LUY_KE']?.toDouble();
    giaTriConLai = json['GIA_TRI_CON_LAI']?.toDouble();
    bpsdtsId = json['BPSDTS_ID']?.toString();
    dtsdtsId = json['DTSDTS_ID']?.toString();
    bpsdtsIdDraf = json['BPSDTS_ID_DRAF']?.toString();
    dtsdtsIdDraf = json['DTSDTS_ID_DRAF']?.toString();
    maTinhTrangSuDung = json['MA_TINH_TRANG_SU_DUNG']?.toString();
    maHinhThucSuDung = json['MA_HINH_THUC_SU_DUNG']?.toString();
    maHienTrangSuDung = json['MA_HIEN_TRANG_SU_DUNG']?.toString();
    pheDuyetQuyetToan = json['PHE_DUYET_QUYET_TOAN'];
    tongDienTich = json['TONG_DIEN_TICH']?.toDouble();
    soTang = json['SO_TANG']?.toInt();
    bienKiemSoat = json['BIEN_KIEM_SOAT']?.toString();
    nhanHieu = json['NHAN_HIEU']?.toString();
    soChoNgoi = json['SO_CHO_NGOI']?.toInt();
    donViId = json['DON_VI_ID']?.toString();
    nhomTaiSanId = json['NHOM_TAI_SAN_ID']?.toString();
    donViIdDraf = json['DON_VI_ID_DRAF']?.toString();
    nhomTaiSanIdDraf = json['NHOM_TAI_SAN_ID_DRAF']?.toString();
    loaiBienDong = json['LOAI_BIEN_DONG']?.toDouble();
    chungLoai = json['CHUNG_LOAI']?.toString();
    diaChiNha = json['DIA_CHI_NHA']?.toString();
    diaChiDat = json['DIA_CHI_DAT']?.toString();
    hinhThucSuDungChuyenDung =
        json['HINH_THUC_SU_DUNG_CHUYEN_DUNG']?.toString();
    lyDoGiamTS = json['LY_DO_GIAM_TS']?.toString();
    lyDoTang = json['LY_DO_TANG']?.toString();
    pheDuyetQuyetToanDraf = json['PHE_DUYET_QUYET_TOAN_DRAF']?.toInt();
    nguoiSuDung = json['NGUOI_SU_DUNG']?.toString();

    if (json['LOAI_BIEN_DONGS'] != null) {
      loaiBienDongs = <LoaiBienDongItem>[];
      json['LOAI_BIEN_DONGS'].forEach((v) {
        loaiBienDongs!.add(LoaiBienDongItem.fromJson(v));
      });
    }
  }

  /// convert a list dynamic to a list LoaiBienDongs
  static List<LoaiBienDongs> listFromJson(List<dynamic> list) {
    List<LoaiBienDongs> rows =
        list.map((i) => LoaiBienDongs.fromJson(i)).toList();
    return rows;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['MA_TAI_SAN'] = maTaiSan;
    data['TEN_TAI_SAN'] = tenTaiSan;
    data['TEN_DTSDTS'] = tenDTSDTS;
    data['TEN_BPSDTS'] = tenBPSDTS;
    data['TEN_NHOM_TAI_SAN'] = tenNhomTaiSan;
    data['NGAY_SU_DUNG'] = ngaySuDung;
    data['NGAY_BIEN_DONG'] = ngayBienDong;
    data['NAM_SAN_XUAT'] = namSanXuat;
    data['NUOC_SAN_XUAT'] = nuocSanXuat;
    data['THONG_SO_KT'] = thongSoKT;
    data['NGUYEN_GIA'] = nguyenGia;
    data['NGUYEN_GIA_GOC'] = nguyenGiaGoc;
    data['CONG_SUAT'] = congSuat;
    data['QRCODE'] = qrCode;
    data['NGUYEN_GIA_BANG_CHU'] = nguyenGiaBangChu;
    data['NAM_SU_DUNG'] = namSuDung;
    data['TAI_SAN_ID_DRAF'] = taiSanIdDraf;
    data['TAI_SAN_ID'] = taiSanId;
    data['LOAI_TAI_SAN_GOC'] = loaiTaiSanGoc;
    data['CHANGE_INDEX'] = changeIndex;
    data['DA_GIAM'] = daGiam;
    data['NGAY_TINH'] = ngayTinh;
    data['SO_LUONG'] = soLuong;
    data['KHOI_LUONG_SO_LUONG'] = khoiLuongSoLuong;
    data['HAO_MON_NAM'] = haoMonNam;
    data['HAO_MON_LUY_KE'] = haoMonLuyKe;
    data['KHAU_HAO_NAM'] = khauHaoNam;
    data['MA_DIA_BAN'] = maDiaBan;
    data['KHAU_HAO_LUY_KE'] = khauHaoLuyKe;
    data['GIA_TRI_CON_LAI'] = giaTriConLai;
    data['BPSDTS_ID'] = bpsdtsId;
    data['DTSDTS_ID'] = dtsdtsId;
    data['BPSDTS_ID_DRAF'] = bpsdtsIdDraf;
    data['DTSDTS_ID_DRAF'] = dtsdtsIdDraf;
    data['MA_TINH_TRANG_SU_DUNG'] = maTinhTrangSuDung;
    data['MA_HINH_THUC_SU_DUNG'] = maHinhThucSuDung;
    data['MA_HIEN_TRANG_SU_DUNG'] = maHienTrangSuDung;
    data['PHE_DUYET_QUYET_TOAN'] = pheDuyetQuyetToan;
    data['TONG_DIEN_TICH'] = tongDienTich;
    data['SO_TANG'] = soTang;
    data['BIEN_KIEM_SOAT'] = bienKiemSoat;
    data['NHAN_HIEU'] = nhanHieu;
    data['SO_CHO_NGOI'] = soChoNgoi;
    data['DON_VI_ID'] = donViId;
    data['NHOM_TAI_SAN_ID'] = nhomTaiSanId;
    data['DON_VI_ID_DRAF'] = donViIdDraf;
    data['NHOM_TAI_SAN_ID_DRAF'] = nhomTaiSanIdDraf;
    data['LOAI_BIEN_DONG'] = loaiBienDong;
    data['CHUNG_LOAI'] = chungLoai;
    data['DIA_CHI_NHA'] = diaChiNha;
    data['DIA_CHI_DAT'] = diaChiDat;
    data['HINH_THUC_SU_DUNG_CHUYEN_DUNG'] = hinhThucSuDungChuyenDung;
    data['LY_DO_GIAM_TS'] = lyDoGiamTS;
    data['LY_DO_TANG'] = lyDoTang;
    data['PHE_DUYET_QUYET_TOAN_DRAF'] = pheDuyetQuyetToanDraf;
    data['NGUOI_SU_DUNG'] = nguoiSuDung;

    if (loaiBienDongs != null) {
      data['LOAI_BIEN_DONGS'] = loaiBienDongs!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class LoaiBienDongItem {
  String? tenLoaiBienDong;
  BienDong? bienDong;

  LoaiBienDongItem({
    this.tenLoaiBienDong,
    this.bienDong,
  });

  LoaiBienDongItem.fromJson(Map<String, dynamic> json) {
    tenLoaiBienDong = json['TEN_LOAI_BIEN_DONG']?.toString();
    bienDong =
        json['BIEN_DONG'] != null ? BienDong.fromJson(json['BIEN_DONG']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['TEN_LOAI_BIEN_DONG'] = tenLoaiBienDong;
    if (bienDong != null) {
      data['BIEN_DONG'] = bienDong!.toJson();
    }
    return data;
  }
}

class BienDong {
  String? taiSanId;
  String? maTaiSan;
  String? tenTaiSan;
  String? ngaySuDung;
  String? ngayBienDong;
  double? nguyenGia;
  double? nguyenGiaGoc;
  String? lyDoBienDong;
  String? tenDonVi;
  double? haoMonLuyKe;

  BienDong({
    this.taiSanId,
    this.maTaiSan,
    this.tenTaiSan,
    this.ngaySuDung,
    this.ngayBienDong,
    this.nguyenGia,
    this.nguyenGiaGoc,
    this.lyDoBienDong,
    this.tenDonVi,
    this.haoMonLuyKe,
  });

  BienDong.fromJson(Map<String, dynamic> json) {
    taiSanId = json['TAI_SAN_ID']?.toString();
    maTaiSan = json['MA_TAI_SAN']?.toString();
    tenTaiSan = json['TEN_TAI_SAN']?.toString();
    ngaySuDung = json['NGAY_SU_DUNG']?.toString();
    ngayBienDong = json['NGAY_BIEN_DONG']?.toString();
    nguyenGia = json['NGUYEN_GIA']?.toDouble();
    nguyenGiaGoc = json['NGUYEN_GIA_GOC']?.toDouble();
    lyDoBienDong = json['LY_DO_BIEN_DONG']?.toString();
    tenDonVi = json['TEN_DON_VI']?.toString();
    haoMonLuyKe = json['HAO_MON_LUY_KE']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['TAI_SAN_ID'] = taiSanId;
    data['MA_TAI_SAN'] = maTaiSan;
    data['TEN_TAI_SAN'] = tenTaiSan;
    data['NGAY_SU_DUNG'] = ngaySuDung;
    data['NGAY_BIEN_DONG'] = ngayBienDong;
    data['NGUYEN_GIA'] = nguyenGia;
    data['NGUYEN_GIA_GOC'] = nguyenGiaGoc;
    data['LY_DO_BIEN_DONG'] = lyDoBienDong;
    data['TEN_DON_VI'] = tenDonVi;
    data['HAO_MON_LUY_KE'] = haoMonLuyKe;
    return data;
  }
}

// Extension to convert LoaiBienDongs to TaiSan
extension LoaiBienDongsToTaiSan on LoaiBienDongs {
  TaiSan convertToTaiSan() {
    var taiSan = TaiSan(
      maTS: maTaiSan,
      tenTS: tenTaiSan,
      tenDTSDTS: tenDTSDTS,
      tenBPSDTS: tenBPSDTS,
      tenNhomTS: tenNhomTaiSan,
      ngaySuDung: ngaySuDung,
      ngayBienDong: ngayBienDong,
      namSanXuat: namSanXuat,
      nuocSanXuat: nuocSanXuat,
      thongSoKyThuat: thongSoKT,
      nguyenGia: nguyenGia,
      nguyenGiaGoc: nguyenGiaGoc,
      congSuat: congSuat,
      qrCode: qrCode,
      nguyenGiaText: nguyenGiaBangChu,
      namSuDung: namSuDung,
      tsId: taiSanId,
      loaiTaiSanGoc: loaiTaiSanGoc,
      changeIndex: changeIndex,
      daGiam: daGiam,
      ngayTinh: ngayTinh,
      soLuong: soLuong?.toInt() ?? 1,
      khoiLuongSoLuong: khoiLuongSoLuong?.toInt() ?? 0,
      haoMonNam: haoMonNam?.toInt() ?? 0,
      haoMonLuyKe: haoMonLuyKe?.toInt() ?? 0,
      khauHaoNam: khauHaoNam?.toInt() ?? 0,
      maDiaBan: maDiaBan,
      khauHaoLuyKe: khauHaoLuyKe?.toInt() ?? 0,
      giaTriConLai: giaTriConLai,
      BPSDTSID: bpsdtsId,
      DTSDTSID: dtsdtsId,
      maTinhTrangSuDung: maTinhTrangSuDung,
      maHinhThucSuDung: maHinhThucSuDung,
      maHienTrangSuDung: maHienTrangSuDung,
      pheDuyetQuyetToan: pheDuyetQuyetToan,
      tongDienTich: tongDienTich?.toInt() ?? 0,
      soTang: soTang,
      bienKiemSoat: bienKiemSoat,
      nhanHieu: nhanHieu,
      soChoNgoi: soChoNgoi,
      donViId: donViId,
      nhomTaiSanId: nhomTaiSanId,
      loanBienDong: loaiBienDong?.toInt() ?? 0,
      chungLoai: chungLoai,
      diaChiNha: diaChiNha,
      diaChiDat: diaChiDat,
      hinhThucSuDungChuyenNhuong: hinhThucSuDungChuyenDung,
      hasScanned: false,
    );
    // Set soLuongKiemKe after creation
    taiSan.soLuongKiemKe = 0;
    return taiSan;
  }
}
