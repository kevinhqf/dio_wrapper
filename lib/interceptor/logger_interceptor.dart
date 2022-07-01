import 'dart:developer';

import 'package:dio/dio.dart';

class LoggerInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('-----------------DioWrapper ${response.requestOptions.method.toUpperCase()} Request------------------>',
        time: DateTime.now());
    log('url:${response.requestOptions.uri.toString()}');
    log('request headers:${response.requestOptions.headers}');
    log('request params:${response.requestOptions.data}');
    log('response headers:${response.headers}');
    log('response data:${response.data}');
    log('<-----------------DioWrapper ${response.requestOptions.method.toUpperCase()} Response------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log('-----------------DioWrapper ${err.requestOptions.method.toUpperCase()} Error------------------>',
        time: DateTime.now());
    log('msg:${err.message}');
    log('url:${err.requestOptions.uri.toString()}');
    log('request headers:${err.requestOptions.headers}');
    log('params:${err.requestOptions.data}');
    log('<-----------------DioWrapper ${err.requestOptions.method.toUpperCase()} Error------------------');
    super.onError(err, handler);
  }
}
