import 'package:flutter_test/flutter_test.dart';

import 'package:dio_wrapper/dio_wrapper.dart';

void main() {
  test('adds one to input values', () {
   var http = Http(baseUrl: 'https://suggest.taobao.com');
   http.get("/sug",param: {
     'code': 'utf-8',
     'q':'卫衣',
     'callback':'cb'
   });

  });
}
