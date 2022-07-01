import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class CacheInterceptor extends InterceptorsWrapper{
  final box = GetStorage();

}

class CacheStrategy{

}