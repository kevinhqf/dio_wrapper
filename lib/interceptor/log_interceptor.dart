import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LogInterceptor extends InterceptorsWrapper{
  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: false, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
    ),
  );
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d({
      "type":"onRequest",
      "url":options.uri.toString(),
      "headers":options.headers,
      "params":options.data,
    });
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d({
      "type":"onResponse",
      "url":response.realUri.toString(),
      "headers":response.headers,
      "data":response.data,
    });
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e({
      "type":"onError",
      "msg":err.message,
      "url":err.requestOptions.uri.toString(),
      "requestHeaders":err.requestOptions.headers,
      "params":err.requestOptions.data,
    },err.error,err.stackTrace);
    super.onError(err, handler);
  }

}