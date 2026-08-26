import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:qltstc_kiemke/constants/api_constants.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/bbkk.dart';
import 'package:qltstc_kiemke/models/error_result.dart';
import 'package:qltstc_kiemke/models/taisanmobile.dart';
import 'package:qltstc_kiemke/services/dio.dart';

class BBKKService {
  static final BBKKService _instance = new BBKKService._internal();

  factory BBKKService() {
    return _instance;
  }

  BBKKService._internal();

  static BBKKService sharedInstance() {
    return _instance;
  }

  BBKK? currentRecord;
  List<BBKK> existedBBKK = [];

  Future<bool> createBBKK({bool? isNhap}) {
    currentRecord!.TrangThai = (isNhap ?? false) ? 6 : 2;
    currentRecord!.LaLuuNhap = (isNhap == true) ? null : 1;
    var url = this.currentRecord?.Id == null
        ? APIConstants.POST_SaveBBKK
        : APIConstants.POST_UpdateBBKK + "?id=${this.currentRecord?.Id}";
    print(currentRecord!.toJson().toString());
    return APIClient.instance.dio
        .post(
      url,
      options: APIClient.createPostOption(
        buildCacheOptions(Duration(days: 1), forceRefresh: true),
        // ).copyWith(contentType: Headers.formUrlEncodedContentType),
        contentType: RequestConstant.REQUEST_CONTENT_TYPE,
      ),
      data: currentRecord!.toJson(),
    )
        .then(
      (value) {
        try {
          return true;
        } catch (e) {
          return false;
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return false;
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return false;
    });
  }

  Future<bool> updateBBKK({bool? isNhap}) {
    currentRecord!.TrangThai = (isNhap ?? false) ? 6 : 2;
    currentRecord!.LaLuuNhap = (isNhap == true) ? null : 1;
    var url = APIConstants.POST_UpdateBBKK + "?id=${this.currentRecord?.Id}";
    print(currentRecord!.toJson().toString());
    // if (currentRecord!.ListTaiSan != null &&
    //     currentRecord!.ListTaiSan!.any(
    //       (element) => element.maHinhThucXuLy != null,
    //     )) {
    // currentRecord!.ListTaiSanTamThoi = currentRecord!.ListTaiSanTamThoi ?? [];
    // currentRecord!.ListTaiSanTamThoi!.removeWhere(
    //   (element) => element.taisanId != null,
    // );
    // currentRecord!.ListTaiSan!.forEach((element) {
    //   // if (element.maHinhThucXuLy != null) {
    //   if (element.trangThaiKK == 2 || element.trangThaiKK == 4) {
    //     currentRecord!.ListTaiSanTamThoi!.add(element.convertToTSBS());
    //   }
    // });
    // }
    if (currentRecord?.ListTaiSanTamThoi != null &&
        currentRecord!.ListTaiSanTamThoi!.length > 0) {
      currentRecord!.ListTaiSanTamThoi!.forEach((element) {
        element.bienBanId = currentRecord!.Id;
      });
    }
    return APIClient.instance.dio
        .put(
      url,
      options: APIClient.createPostOption(
        buildCacheOptions(Duration(days: 1), forceRefresh: true),
        // ).copyWith(contentType: Headers.formUrlEncodedContentType),
        contentType: RequestConstant.REQUEST_CONTENT_TYPE,
      ),
      data: currentRecord!.toJson(),
    )
        .then(
      (value) {
        try {
          return true;
        } catch (e) {
          return false;
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return false;
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return false;
    });
  }

  Future<List<BBKK>?> getBBKKs() {
    var url = APIConstants.POST_GetBBKKs;
    return APIClient.instance.dio
        .post(
      url,
      data: {"page": 0, "pageSize": 1000},
      options: APIClient.createPostOption(
        buildCacheOptions(Duration(milliseconds: 1), forceRefresh: true),
        contentType: RequestConstant.REQUEST_CONTENT_TYPE,
      ),
    )
        .then(
      (value) {
        try {
          var ts = BBKK.listFromJson(value.data);
          existedBBKK = ts;
          return ts;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return null;
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return null;
    });
  }

  Future<BBKK?> getBBKKbyId(String id) {
    var url = APIConstants.POST_GetBBKKByID + id;
    return APIClient.instance.dio
        .get(
      url,
      options: APIClient.createGetOption(
        buildCacheOptions(Duration(milliseconds: 1), forceRefresh: true),
      ),
    )
        .then(
      (value) {
        try {
          var bbkk = BBKK.fromJson(value.data);
          // var ngaykkString = DateFormat(
          //   "yyyy/MM/dd",
          // ).format(DateTime.now());
          // var ngaykk = DateFormat("dd/MM/yyyy").parse(bbkk.NgayKiemKe!);
          // if (ngaykk.year > 2010)
          //   ngaykkString = DateFormat("yyyy/MM/dd").format(ngaykk);
          bbkk.ListTaiSan = [];
          if (bbkk.ListTaiSanInBBKK!.length > 0) {
            // for (int i = 1; i < 100; i++)
            bbkk.ListTaiSanInBBKK!.forEach((element) async {
              // var ts = await TaiSanService.sharedInstance()
              //     .getThongTinTaiSan(element!.taiSanId!, ngaykkString);
              var ts = element.convertToTaiSan();
              ts.soLuongKiemKe = element.soLuongKiemKe;
              ts.maHinhThucXuLy = element.maHinhThucXuLy;
              bbkk.ListTaiSan!.add(ts);
            });
          }
          return bbkk;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return null;
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return null;
    });
  }

  Future<bool> deleteBBKK(String id) {
    var url = APIConstants.DELETE_DeleteBBKK + "?id=$id";
    return APIClient.instance.dio
        .delete(
      url,
      options: APIClient.createPostOption(
        buildCacheOptions(Duration(days: 1), forceRefresh: true),
        // ).copyWith(contentType: Headers.formUrlEncodedContentType),
        contentType: RequestConstant.REQUEST_CONTENT_TYPE,
      ),
    )
        .then(
      (value) {
        try {
          return true;
        } catch (e) {
          return false;
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return false;
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return false;
    });
  }

  Future<List<TaiSanMobile>?> getDanhSachTaiSans(
      String ngay, String boPhan, String donViId) {
    var url = APIConstants.GET_DanhSachTS.replaceAll(
      "{0}",
      ngay,
    ).replaceAll("{1}", boPhan).replaceAll("{2}", donViId);
    return APIClient.instance.dio
        .get(
      url,
      options: APIClient.createGetOption(
        buildCacheOptions(Duration(days: 1), forceRefresh: true),
      ),
    )
        .then(
      (value) {
        try {
          var lbd = TaiSanMobile.listFromJson(value.data);
          return lbd;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        ErrorResult.fromJson(e.response.data);
        return null;
      },
    ).catchError((err) {
      ErrorResult.fromJson(err.response.data);
      return null;
    });
  }

  Future<bool> checkSoBienBanExists(String soBK, String id, String donViId) {
    var url = APIConstants.GET_CheckTrungBBKK.replaceAll(
      "{0}",
      soBK,
    ).replaceAll("{1}", id).replaceAll("{2}", donViId);
    return APIClient.instance.dio
        .get(
      url,
      options: APIClient.createGetOption(
        buildCacheOptions(Duration(days: 1), forceRefresh: true),
      ),
    )
        .then(
      (value) {
        try {
          return value.data as bool;
        } catch (e) {
          return false;
        }
      },
      onError: (e) {
        ErrorResult.fromJson(e.response.data);
        return false;
      },
    ).catchError((err) {
      ErrorResult.fromJson(err.response.data);
      return false;
    });
  }
}
