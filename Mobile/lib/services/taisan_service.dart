import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:qltstc_kiemke/constants/api_constants.dart';
import 'package:qltstc_kiemke/models/bbkk.dart';
import 'package:qltstc_kiemke/models/bieudotanggiam.dart';
import 'package:qltstc_kiemke/models/bieudotonghop.dart';
import 'package:qltstc_kiemke/models/loai_bien_dongs.dart';
import 'package:qltstc_kiemke/models/quetmaccdc.dart';
import 'package:qltstc_kiemke/models/taisan.dart';
import 'package:qltstc_kiemke/services/dio.dart';

class TaiSanService {
  static final TaiSanService _instance = new TaiSanService._internal();

  factory TaiSanService() {
    return _instance;
  }

  TaiSanService._internal();

  static TaiSanService sharedInstance() {
    return _instance;
  }

  BBKK? currentRecord;
  List<BieuDoTongHop> listTS = [];

  Future<TaiSan?> getThongTinTaiSan(String tsId, String ngayKiemKe) {
    var url = APIConstants.GET_ThongTinTS.replaceAll(
      "{0}",
      tsId,
    ).replaceAll("{1}", ngayKiemKe);
    return APIClient.instance.dio
        .get(
          url,
          options: APIClient.createGetOption(
            buildCacheOptions(Duration(days: 1), forceRefresh: true),
          ),
        )
        .timeout(Duration(milliseconds: 600000))
        .then(
      (value) {
        try {
          var ts = TaiSan.fromJson(value.data);
          return ts;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        try {
          if (e is DioError && e.response != null) {
            // Log error if needed
            print('API Error: ${e.message}');
          }
        } catch (parseError) {
          // Handle parsing error silently
          print('Error parsing response: $parseError');
        }
        return null;
      },
    ).catchError((err) {
      try {
        if (err is DioError) {
          if (err.response != null) {
            // Server responded with error status
            print(
                'Server Error: ${err.response?.statusCode} - ${err.response?.data}');
          } else {
            // Network error, timeout, etc.
            print('Network Error: ${err.message}');
          }
        } else {
          print('Unexpected Error: $err');
        }
      } catch (parseError) {
        // Handle parsing error silently
        print('Error handling exception: $parseError');
      }
      return null;
    });
  }

  Future<LoaiBienDongs?> getThongTinTaiSanDetail(
      String tsId, String ngayKiemKe) {
    var url = APIConstants.GET_ThongTinTSQuetQR.replaceAll(
      "{0}",
      tsId,
    ).replaceAll("{1}", ngayKiemKe);
    return APIClient.instance.dio
        .get(
          url,
          options: APIClient.createGetOption(
            buildCacheOptions(Duration(days: 1), forceRefresh: true),
          ),
        )
        .timeout(Duration(milliseconds: 600000))
        .then(
      (value) {
        try {
          var ts = LoaiBienDongs.fromJson(value.data);
          return ts;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        try {
          if (e is DioError && e.response != null) {
            // Log error if needed
            print('API Error: ${e.message}');
          }
        } catch (parseError) {
          // Handle parsing error silently
          print('Error parsing response: $parseError');
        }
        return null;
      },
    ).catchError((err) {
      try {
        if (err is DioError) {
          if (err.response != null) {
            // Server responded with error status
            print(
                'Server Error: ${err.response?.statusCode} - ${err.response?.data}');
          } else {
            // Network error, timeout, etc.
            print('Network Error: ${err.message}');
          }
        } else {
          print('Unexpected Error: $err');
        }
      } catch (parseError) {
        // Handle parsing error silently
        print('Error handling exception: $parseError');
      }
      return null;
    });
  }

  Future<QuetMaCCDC?> getThongTinCCDCDetail(String tsId, String ngayKiemKe) {
    var url = APIConstants.GET_ThongTinCCDCQuetQR.replaceAll(
      "{0}",
      tsId,
    );
    return APIClient.instance.dio
        .get(
          url,
          options: APIClient.createGetOption(
            buildCacheOptions(Duration(days: 1), forceRefresh: true),
          ),
        )
        .timeout(Duration(milliseconds: 600000))
        .then(
      (value) {
        try {
          var ts = QuetMaCCDC.fromJson(value.data);
          return ts;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        try {
          if (e is DioError && e.response != null) {
            // Log error if needed
            print('API Error: ${e.message}');
          }
        } catch (parseError) {
          // Handle parsing error silently
          print('Error parsing response: $parseError');
        }
        return null;
      },
    ).catchError((err) {
      try {
        if (err is DioError) {
          if (err.response != null) {
            // Server responded with error status
            print(
                'Server Error: ${err.response?.statusCode} - ${err.response?.data}');
          } else {
            // Network error, timeout, etc.
            print('Network Error: ${err.message}');
          }
        } else {
          print('Unexpected Error: $err');
        }
      } catch (parseError) {
        // Handle parsing error silently
        print('Error handling exception: $parseError');
      }
      return null;
    });
  }

  Future<BieuDoTangGiam?> getBieuDoTangGiam(String donViId, String namKiemKe) {
    var url = APIConstants.GET_BieuDoTangGiam.replaceAll(
      "{0}",
      donViId,
    ).replaceAll("{1}", namKiemKe);
    return APIClient.instance.dio
        .get(
          url,
          options: APIClient.createGetOption(
            buildCacheOptions(Duration(days: 1), forceRefresh: true),
          ),
        )
        .timeout(Duration(milliseconds: 600000))
        .then(
      (value) {
        try {
          var ts = BieuDoTangGiam.fromJson(value.data);
          return ts;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        try {
          if (e is DioError && e.response != null) {
            // Log error if needed
            print('API Error: ${e.message}');
          }
        } catch (parseError) {
          // Handle parsing error silently
          print('Error parsing response: $parseError');
        }
        return null;
      },
    ).catchError((err) {
      try {
        if (err is DioError) {
          if (err.response != null) {
            // Server responded with error status
            print(
                'Server Error: ${err.response?.statusCode} - ${err.response?.data}');
          } else {
            // Network error, timeout, etc.
            print('Network Error: ${err.message}');
          }
        } else {
          print('Unexpected Error: $err');
        }
      } catch (parseError) {
        // Handle parsing error silently
        print('Error handling exception: $parseError');
      }
      return null;
    });
  }

  Future<List<BieuDoTongHop>?> getBieuDoTongHop(
      String donViId, String namKiemKe) {
    var url = APIConstants.GET_BieuDoTongHop.replaceAll(
      "{0}",
      donViId,
    ).replaceAll("{1}", namKiemKe);
    return APIClient.instance.dio
        .get(
          url,
          options: APIClient.createGetOption(
            buildCacheOptions(Duration(days: 1), forceRefresh: true),
          ),
        )
        .timeout(Duration(milliseconds: 600000))
        .then(
      (value) {
        try {
          var ts = BieuDoTongHop.fromJsonList(value.data);
          listTS = ts;
          return listTS;
        } catch (e) {
          return null;
        }
      },
      onError: (e) {
        try {
          if (e is DioError && e.response != null) {
            // Log error if needed
            print('API Error: ${e.message}');
          }
        } catch (parseError) {
          // Handle parsing error silently
          print('Error parsing response: $parseError');
        }
        return null;
      },
    ).catchError((err) {
      try {
        if (err is DioError) {
          if (err.response != null) {
            // Server responded with error status
            print(
                'Server Error: ${err.response?.statusCode} - ${err.response?.data}');
          } else {
            // Network error, timeout, etc.
            print('Network Error: ${err.message}');
          }
        } else {
          print('Unexpected Error: $err');
        }
      } catch (parseError) {
        // Handle parsing error silently
        print('Error handling exception: $parseError');
      }
      return null;
    });
  }
}
