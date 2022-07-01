library dio_wrapper;

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:dio_wrapper/interceptor/adapter_interceptor.dart';

import 'interceptor/connection_interceptor.dart';
import 'interceptor/logger_interceptor.dart';

///
class DioWrapper {
  Map<String, dynamic> headers;
  final String baseUrl;
  final int connectionTimeout;

  final int receiveTimeout;
  CacheOptions? cacheOptions;
  RetryInterceptor? retryInterceptor;
  late BaseOptions options;
  late Dio _dio;
  final CancelToken _cancelToken = CancelToken();
  String? cachePath;

  DioWrapper(
      {required this.baseUrl,
      this.connectionTimeout = 30000,
      this.receiveTimeout = 30000,
      this.cacheOptions,
      this.retryInterceptor,
      this.cachePath,
      this.headers = const {}}) {
    _init();
  }

  _init() {
    options = BaseOptions(
        connectTimeout: connectionTimeout,
        receiveTimeout: receiveTimeout,
        baseUrl: baseUrl);
    cacheOptions ??= CacheOptions(
        hitCacheOnErrorExcept: [401, 404, 403],
        priority: CachePriority.normal,
        policy: CachePolicy.request,
        cipher: null,
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        allowPostMethod: false,
        maxStale: const Duration(days: 1),
        store: cachePath == null
            ? MemCacheStore()
            : BackupCacheStore(
                primary: MemCacheStore(),
                secondary: DbCacheStore(databasePath: cachePath!)));
    _dio = Dio(options);
    retryInterceptor ??= RetryInterceptor(
      dio: _dio,
      logPrint: log, // specify log function (optional)
      retries: 3, // retry count (optional)
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    );

    _dio.interceptors.add(ConnectionInterceptor());
    _dio.interceptors.add(retryInterceptor!);
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions!));
    _dio.interceptors.add(AdapterInterceptor(headers: headers));
    _dio.interceptors.add(LoggerInterceptor());
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  Future get(
    String path, {
    Map<String, dynamic> param = const {},
    CancelToken? token,
  }) async {
    Response response = await _dio.get(path,
        queryParameters: param, cancelToken: token ?? _cancelToken);
    return response.data;
  }

  Future post(
    String path, {
    Map<String, dynamic> query = const {},
    Map<String, dynamic> data = const {},
    CancelToken? token,
  }) async {
    Response response = await _dio.post(path,
        queryParameters: query, data: data, cancelToken: token ?? _cancelToken);
    return response.data;
  }

  Future delete(
    String path, {
    Map<String, dynamic> query = const {},
    Map<String, dynamic> data = const {},
    CancelToken? token,
  }) async {
    Response response = await _dio.delete(path,
        data: data, queryParameters: query, cancelToken: token ?? _cancelToken);
    return response.data;
  }

  Future put(
    String path, {
    Map<String, dynamic> query = const {},
    Map<String, dynamic> data = const {},
    CancelToken? token,
  }) async {
    Response response = await _dio.put(path,
        data: data, queryParameters: query, cancelToken: token ?? _cancelToken);
    return response.data;
  }

  Future patch(
    String path, {
    Map<String, dynamic> query = const {},
    Map<String, dynamic> data = const {},
    CancelToken? token,
  }) async {
    Response response = await _dio.patch(path,
        data: data, queryParameters: query, cancelToken: token ?? _cancelToken);
    return response.data;
  }

  Future uploadFile(
    String path,
    String filePath,
    String fileName, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'type': 'file',
      ...?params,
    });
    var response = await _dio.post(path,
        options: options,
        data: formData,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  void addInterceptor(Interceptor e) {
    _dio.interceptors.add(e);
  }
}
