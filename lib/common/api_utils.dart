import 'package:dio/dio.dart';

class Api {
  static Api _instance;

  static Api get instance {
    if (_instance == null) {
      _instance = Api._internal();
    }
    return _instance;
  }

  static Dio get dio => instance._dio;

  Api._internal();

  Dio _dio = Dio();

  // Future<Response<T>> get<T>(String url, {
  //   Map<String, dynamic> queryParams,
  //   Options options,
  //   CancelToken cancelToken,
  //   void Function(int, int) onReceiveProgress
  // }) {
  //   return _dio.get(url,
  //     queryParameters: 
  //   );
  // }
}