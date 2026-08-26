import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:qltstc_kiemke/constants/api_constants.dart';
import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/models/error_result.dart';
import 'package:qltstc_kiemke/models/nguoisudung.dart';
import 'package:qltstc_kiemke/models/nhomtaisan.dart';
import 'package:qltstc_kiemke/models/user.dart';
import 'package:qltstc_kiemke/services/dio.dart';
import 'package:qltstc_kiemke/utils/share_preferences_utils.dart';

class UserService {
  static final UserService _instance = new UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  static UserService sharedInstance() {
    return _instance;
  }

  List<BPSD> listBPSD = [];
  List<NguoiSuDung> listNSD = [];
  List<NhomTS> listNhomTS = [];
  UserInfo? currentUser;

  Future<UserInfo> login(String username, String password) {
    var url = APIConstants.LOGIN;

    return APIClient.instance.dio
        .post(
      url,
      data: {
        // 'username': username.isEmpty ? "KHTC_001" : username,
        // 'password': password.isEmpty ? "admin@123" : password,
        'username': username,
        'password': password,
        'grant_type': "password",
        "client_id": "koFeApp",
        "donvi": "null",
      },
      options: APIClient.createPostOption(
        buildCacheOptions(Duration(days: 1), forceRefresh: true),
      ).copyWith(contentType: Headers.formUrlEncodedContentType),
    )
        .then(
      (value) async {
        try {
          var user = UserInfo.fromJson(value.data);
          SharedPreferencesUtils.setToken(user.accessToken!);
          this.currentUser = user;
          await getBPSD(refresh: true);
          return user;
        } catch (e) {
          return new UserInfo(message: "Xảy ra lỗi đăng nhập");
        }
      },
      onError: (e) {
        if (e.response == null)
          return new UserInfo(message: e.statusCode);
        else {
          var error = ErrorResult.fromJson(e.response.data);
          return new UserInfo(message: error.errorDescription);
        }
      },
    ).catchError((err) {
      try {
        var error = ErrorResult.fromJson(err.response.data);
        return new UserInfo(message: error.errorDescription);
      } catch (e) {
        return new UserInfo(message: "Xảy ra lỗi đăng nhập");
      }
    });
  }

  Future<List<BPSD>> getBPSD({bool refresh = false}) {
    var url = APIConstants.GET_BoPhanSuDung;
    url = url.replaceAll("{0}", currentUser!.donviId!);
    return APIClient.instance.dio
        .get(
      url,
      options: APIClient.createGetOption(
        buildCacheOptions(Duration(days: 7), forceRefresh: refresh),
      ),
    )
        .then(
      (value) {
        try {
          var bpsds = BPSD.listFromJson(value.data);
          listBPSD = [];
          // listBPSD = bpsds.toList();
          bpsds.forEach((element) {
            listBPSD.add(element);
            if (element.children!.length > 0)
              element.children!.forEach((e) {
                e.title = "-- " +
                    e.title.replaceAll(
                      "- " + (element.tooltip ?? ""),
                      "",
                    );
                listBPSD.add(e);
              });
            // listBPSD.addAll(element.children!);
          });
          return listBPSD;
        } catch (e) {
          return <BPSD>[];
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return <BPSD>[];
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return <BPSD>[];
    });
  }

  Future<List<NguoiSuDung>> getNSD(String BPSDId, {bool refresh = false}) {
    var url = APIConstants.GET_NguoiSuDung;
    url = url.replaceAll("{0}", BPSDId);
    return APIClient.instance.dio
        .get(
      url,
      options: APIClient.createGetOption(
        buildCacheOptions(Duration(days: 7), forceRefresh: refresh),
      ),
    )
        .then(
      (value) {
        try {
          var bpsds = NguoiSuDung.listFromJson(value.data);
          listNSD = bpsds.toList();
          return listNSD;
        } catch (e) {
          return <NguoiSuDung>[];
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return <NguoiSuDung>[];
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return <NguoiSuDung>[];
    });
  }

  Future<List<NhomTS>> getNhomTS({bool refresh = false}) {
    var url = APIConstants.GET_NhomTS;
    return APIClient.instance.dio
        .get(
      url,
      options: APIClient.createGetOption(
        buildCacheOptions(Duration(days: 7), forceRefresh: refresh),
      ),
    )
        .then(
      (value) {
        try {
          var nhomTSs = NhomTS.listFromJson(value.data);
          this.listNhomTS = nhomTSs;
          return nhomTSs;
        } catch (e) {
          return <NhomTS>[];
        }
      },
      onError: (e) {
        // var error = ErrorResult.fromJson(e.response.data);
        return <NhomTS>[];
      },
    ).catchError((err) {
      // var error = ErrorResult.fromJson(err.response.data);
      return <NhomTS>[];
    });
  }

  void logout() {
    this.currentUser = null;
    SharedPreferencesUtils.setToken(null);
  }
}
