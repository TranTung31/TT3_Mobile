import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:qltstc_kiemke/constants/configs.dart';

import 'package:qltstc_kiemke/utils/share_preferences_utils.dart';

class APIClient {
  static BaseOptions _options = new BaseOptions(
    //    baseUrl: APIConstant.BASE_URL,
    connectTimeout: 600000,
    receiveTimeout: 600000,
    sendTimeout: 600000,
  );
  static Dio _dio = Dio(_options);
  static DioCacheManager? _manager;

  static final APIClient instance = APIClient._internal();

  Dio get dio => _dio;

  APIClient._internal() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //     _dio.interceptors.add(InterceptorsWrapper(
    //       onRequest: (options, handler) {
    //         var token = SharedPreferencesUtils.getToken();
    //         options.headers["Authorization"] = token;
    //         options.headers[RequestConstant.CONTENT_TYPE_KEY] =
    //             RequestConstant.REQUEST_CONTENT_TYPE;
    //         options.headers[RequestConstant.ACCEPT] =
    //             RequestConstant.ACCEPT_CONTENT;
    // //        print(token);
    //       },
    // //         onRequest: (Options myOption, handler)  {
    // //       var token = SharedPreferencesUtils.getToken();
    // //         myOption.headers["Authorization"] = token;
    // //         myOption.headers[RequestConstant.CONTENT_TYPE_KEY] =
    // //             RequestConstant.REQUEST_CONTENT_TYPE;
    // //         myOption.headers[RequestConstant.ACCEPT] =
    // //             RequestConstant.ACCEPT_CONTENT;
    // // //        print(token);
    // //
    // //       return myOption;
    // //     }
    //     ));
    _dio.interceptors.add(getCacheManager().interceptor);

    // final options = CacheOptions(
    //   store: MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576),
    //   // Required.
    //   policy: CachePolicy.refresh,
    //   // Default. Requests first and caches response.
    //   hitCacheOnErrorExcept: [401, 403],
    //   // Optional. Returns a cached response on error if available but for statuses 401 & 403.
    //   priority: CachePriority.normal,
    //   // Optional. Default. Allows 3 cache levels and ease cleanup.
    //   maxStale: const Duration(days: 7),
    //   // Very optional. Overrides any HTTP directive to delete entry past this duration.
    // );
  }

  static Options createGetOption(Options options) {
    var token = SharedPreferencesUtils.getToken();
    options.headers = new Map<String, dynamic>();
    options.headers!["Authorization"] = "Bearer " + token;
    options.headers![RequestConstant.CONTENT_TYPE_KEY] =
        RequestConstant.REQUEST_CONTENT_TYPE;
    options.headers![RequestConstant.ACCEPT] = RequestConstant.ACCEPT_CONTENT;
    return options;
  }

  static Options createPostOption(Options options, {String? contentType}) {
    var token = SharedPreferencesUtils.getToken();
    options.headers = new Map<String, dynamic>();
    options.headers!["Authorization"] = "Bearer " + token;
    print("Bearer " + token);
    options.headers![RequestConstant.CONTENT_TYPE_KEY] =
        contentType ?? Headers.formUrlEncodedContentType;
    // options.headers![RequestConstant.ACCEPT] = RequestConstant.ACCEPT_CONTENT;
    return options;
  }

  static DioCacheManager getCacheManager() {
    if (null == _manager) {
      _manager = DioCacheManager(CacheConfig(databaseName: "qlts"));
    }
    return _manager!;
  }

  static void deleteCacheByKey(String primaryKey, {String? subKey}) {
    getCacheManager().delete(primaryKey, subKey: subKey);
  }
}
