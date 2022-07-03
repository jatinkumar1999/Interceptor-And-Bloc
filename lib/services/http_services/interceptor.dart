import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/app_key/app_key.dart';

class DioInterceptorHandeler extends Interceptor {
  // final DioConnectivityRequestRetrier requestRetrier;
  final Dio dio;
  final Connectivity connectivity;

  DioInterceptorHandeler({
    // required this.requestRetrier,
    required this.dio,
    required this.connectivity,
  });
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
// When the User Change The Connection
//Then hit The Api Again

    print("Error==>>${err.type}");
    print("Error==>>${err.error}");
    if (_shouldRetry(err)) {
      print("dgdsgdgg");
      print("dgdsgdgg==>${_shouldRetry(err)}");
      try {
        StreamSubscription? streamSubscription;
        final responseCompleter = Completer<Response>();

        streamSubscription = connectivity.onConnectivityChanged.listen(
          (connectivityResult) async {
            print("IN THE ON ERROR==>>$connectivityResult");
            if (connectivityResult != ConnectivityResult.none) {
              streamSubscription?.cancel();
              // Complete the completer instead of returning
              responseCompleter.complete(
                dio.request(
                  err.requestOptions.path,
                  cancelToken: err.requestOptions.cancelToken,
                  data: err.requestOptions.data,
                  onReceiveProgress: err.requestOptions.onReceiveProgress,
                  onSendProgress: err.requestOptions.onSendProgress,
                  queryParameters: err.requestOptions.queryParameters,
                  // options: requestOptions,
                ),
              );
              // Response res = await dio.request(
              //   err.requestOptions.path,
              //   cancelToken: err.requestOptions.cancelToken,
              //   data: err.requestOptions.data,
              //   onReceiveProgress: err.requestOptions.onReceiveProgress,
              //   onSendProgress: err.requestOptions.onSendProgress,
              //   queryParameters: err.requestOptions.queryParameters,
              //   // options: requestOptions,
              // );
              // print("-->${res}");
              // handler.resolve(res);
              final res = await responseCompleter.future;
              print("----->>$res");
              return handler.resolve(res);

              // responseCompleter.future;
              // handler.next(err);

              // print("-->${res}");
            }
          },
        );
      } catch (e) {
        print('-->>IN THE CATCHE--$e ');
        // Let any new error from the retrier pass through
        // return e;
      }
    }

    if (err.type == DioErrorType.response) {
      ScaffoldMessenger.of(AppKey.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 800),
          backgroundColor: Colors.red,
          content: Text(err.message),
        ),
      );
    } else if (err.type == DioErrorType.connectTimeout) {
      ScaffoldMessenger.of(AppKey.navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          backgroundColor: Colors.red,
          content: Text("slow Internet "),
        ),
      );
    } else if (err.type == DioErrorType.receiveTimeout) {
      ScaffoldMessenger.of(AppKey.navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          backgroundColor: Colors.red,
          content: Text("slow Internet"),
        ),
      );
    } else if (err.type == DioErrorType.other) {
      ScaffoldMessenger.of(AppKey.navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 800),
          clipBehavior: Clip.antiAlias,
          backgroundColor: Colors.red,
          content: Text("no Internet"),
        ),
      );
    }
    // super.onError(err, handler);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}
