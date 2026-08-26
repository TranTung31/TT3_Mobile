class APIConstants {
  static String LOGIN = "https://qltstc.mof.gov.vn/API/oauth/token";
  static String GET_BoPhanSuDung =
      "https://qltstc.mof.gov.vn/API/API/DMBoPhanSuDung/GetBPSDByDonViAndNgayChungTu?Id={0}&ngayChungTu=2019/12/31&reloadUrl=1";
  static String GET_NguoiSuDung =
      "https://qltstc.mof.gov.vn/API/API/DMDoiTuongSuDung/GetDoiTuongSuDungByParentId?Id={0}";
  static String GET_NhomTS =
      "https://qltstc.mof.gov.vn/API/API/NhomTaiSan/GetFullNhomTaiSanTreeReload?reloadUrl=1";
  static String GET_ThongTinTS =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetInfoTSKK?tsId={0}&ngayKiemKe={1}";
  static String GET_ThongTinTSQuetQR =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetInfoDetailTSKK?tsId={0}&ngayKiemKe={1}";
  static String GET_ThongTinCCDCQuetQR =
      "https://qltstc.mof.gov.vn/API/API/CongCuDungCu/GetCCDCMoBileById?ccdcId={0}";
  static String GET_DanhSachTS =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetTaiSanCanKiemKe_Mobile?donviid={2}&ngay={0}&boPhan={1}";
  static String GET_CheckTrungBBKK =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/CheckBienBanKiemKeExisted?soBK={0}&id={1}&donViID={2}";

  static String GET_BieuDoTangGiam =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetThongTinTangGiamKiemKe?donViId={0}&namKiemKe={1}";
  static String GET_BieuDoTongHop =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetThongTinTongHopKiemKe?donViId={0}&namKiemKe={1}";

  static String POST_GetBBKKs =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetAllBienBanKiemKeMobile?keySearch=";
  static String POST_GetBBKKByID =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/GetBienBanKiemKe/";
  static String POST_SaveBBKK =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/CreateBienBanKiemKeMobile";
  static String POST_UpdateBBKK =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/UpdateBienBanKiemKeMobile";
  static String DELETE_DeleteBBKK =
      "https://qltstc.mof.gov.vn/API/API/KiemKeTaiSan/DeleteBienBanKiemKe";
}

// class APIConstants {
//   static String LOGIN = "http://10.0.0.29:8012/API/oauth/token";
//   static String GET_BoPhanSuDung =
//       "http://10.0.0.29:8012/API/API/DMBoPhanSuDung/GetBPSDByDonViAndNgayChungTu?Id={0}&ngayChungTu=2019/12/31&reloadUrl=1";
//   static String GET_NguoiSuDung =
//       "http://10.0.0.29:8012/API/API/DMDoiTuongSuDung/GetDoiTuongSuDungByParentId?Id={0}";
//   static String GET_NhomTS =
//       "http://10.0.0.29:8012/API/API/NhomTaiSan/GetFullNhomTaiSanTreeReload?reloadUrl=1";
//   static String GET_ThongTinTS =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetInfoTSKK?tsId={0}&ngayKiemKe={1}";
//   static String GET_ThongTinTSQuetQR =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetInfoDetailTSKK?tsId={0}&ngayKiemKe={1}";
//   static String GET_ThongTinCCDCQuetQR =
//       "http://10.0.0.29:8012/API/API/CongCuDungCu/GetCCDCMoBileById?ccdcId={0}";
//   static String GET_DanhSachTS =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetTaiSanCanKiemKe_Mobile?donviid={2}&ngay={0}&boPhan={1}";
//   static String GET_CheckTrungBBKK =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/CheckBienBanKiemKeExisted?soBK={0}&id={1}&donViID={2}";

//   static String GET_BieuDoTangGiam =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetThongTinTangGiamKiemKe?donViId={0}&namKiemKe={1}";
//   static String GET_BieuDoTongHop =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetThongTinTongHopKiemKe?donViId={0}&namKiemKe={1}";

//   static String POST_GetBBKKs =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetAllBienBanKiemKeMobile?keySearch=";
//   static String POST_GetBBKKByID =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/GetBienBanKiemKe/";
//   static String POST_SaveBBKK =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/CreateBienBanKiemKeMobile";
//   static String POST_UpdateBBKK =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/UpdateBienBanKiemKeMobile";
//   static String DELETE_DeleteBBKK =
//       "http://10.0.0.29:8012/API/API/KiemKeTaiSan/DeleteBienBanKiemKe";
// }
