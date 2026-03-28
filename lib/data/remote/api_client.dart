// lib/data/remote/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants.dart';

class ApiClient {
  ApiClient(this._secureStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              final String? token = await _secureStorage.read(
                key: kAccessTokenKey,
              );
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (!AppConfig.remoteServicesEnabled ||
              error.response?.statusCode != 401 ||
              error.requestOptions.extra['skipRefresh'] == true) {
            handler.next(error);
            return;
          }

          final String? refreshToken = await _secureStorage.read(
            key: kRefreshTokenKey,
          );
          if (refreshToken == null || refreshToken.isEmpty) {
            handler.next(error);
            return;
          }

          try {
            final Response<dynamic> refreshResponse = await dio.post<dynamic>(
              '/auth/refresh',
              data: <String, dynamic>{'refreshToken': refreshToken},
              options: Options(extra: <String, dynamic>{'skipRefresh': true}),
            );
            final String newAccessToken =
                (refreshResponse.data as Map<String, dynamic>)['accessToken']
                    as String;
            await _secureStorage.write(
              key: kAccessTokenKey,
              value: newAccessToken,
            );

            final RequestOptions requestOptions = error.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            final Response<dynamic> retried = await dio.fetch<dynamic>(
              requestOptions,
            );
            handler.resolve(retried);
          } on DioException catch (refreshError) {
            handler.next(refreshError);
          }
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio dio;
  final FlutterSecureStorage _secureStorage;

  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: kAccessTokenKey, value: accessToken);
    await _secureStorage.write(key: kRefreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: kAccessTokenKey);
    await _secureStorage.delete(key: kRefreshTokenKey);
  }
}
