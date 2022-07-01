import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class CacheInterceptor extends InterceptorsWrapper{
  final box = GetStorage();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest

    super.onRequest(options, handler);
  }
}

class CacheStrategy{

}