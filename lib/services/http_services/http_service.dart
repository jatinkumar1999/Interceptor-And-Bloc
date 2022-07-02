import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice/services/http_services/interceptor.dart';

class HttpServices {
  late final Dio dio;
  HttpServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://reqres.in/",
        connectTimeout: 500000,
        receiveTimeout: 300000,
      ),
    );

    dio.interceptors.add(
      DioInterceptorHandeler(
        dio: dio,
        connectivity: Connectivity(),
        // requestRetrier: DioConnectivityRequestRetrier(
        //   dio: dio,
        //   connectivity: Connectivity(),
        // ),
      ),
    );
  }

  Future<Response?> getResquest({String? endPoint}) async {
    Response? response;
    try {
      response = await dio.get(
        endPoint.toString(),
      );
    } catch (e) {
      print("GET=============>>$e");
    }

    return response;
  }

  Future<Response?> postResquest({String? endPoint}) async {
    Response? response;

    try {
      response = await dio.post(
        endPoint.toString(),
      );
    } catch (e) {
      print('POST=============>>$e');
    }

    return response;
  }
}
