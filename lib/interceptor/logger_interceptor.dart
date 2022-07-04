import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorsWrapper {
  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 800, // width of the output
        colors: true, // Colorful log messages
        printEmojis: false, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
    ),
  );
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(response.requestOptions);
    logger.i(response.data);
    // log('-----------------DioWrapper ${response.requestOptions.method.toUpperCase()} Request------------------>',
    //     time: DateTime.now());
    // log('url:${response.requestOptions.uri.toString()}');
    // log('request headers:${response.requestOptions.headers}');
    // log('request params:${response.requestOptions.data}');
    // log('response headers:');
    //
    // log('response data:${response.data}');
    // log('<-----------------DioWrapper ${response.requestOptions.method.toUpperCase()} Response------------------');
   handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(err.message,err,err.stackTrace);
    // log('-----------------DioWrapper ${err.requestOptions.method.toUpperCase()} Error------------------>',
    //     time: DateTime.now());
    // log('msg:${err.message}');
    // log('url:${err.requestOptions.uri.toString()}');
    // log('request headers:${err.requestOptions.headers}');
    // log('params:${err.requestOptions.data}');
    // log('<-----------------DioWrapper ${err.requestOptions.method.toUpperCase()} Error------------------');
    super.onError(err, handler);
  }
}
