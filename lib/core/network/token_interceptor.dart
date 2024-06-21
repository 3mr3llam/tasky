import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:tasky/core/config/config.dart';
import 'package:tasky/core/services/token_service.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final Dio dio;

  TokenInterceptor(this.dio);

  bool _isRefreshing = false;

  final _requestsNeedRetry =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add authorization header
    final tokenService = getx.Get.find<TokenService>();
    final token = await tokenService.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null &&
        err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(EndPoints.refreshToken)) {
      // if hasn't not refreshing yet, let's start it
      if (!_isRefreshing) {
        _isRefreshing = true;

        _requestsNeedRetry.add((options: err.requestOptions, handler: handler));
        String? refreshedAccessToken =
            await getx.Get.find<AuthController>().fetchNewAccessToken();
        if (refreshedAccessToken != null) {
          for (var requestNeedRetry in _requestsNeedRetry) {
            //print("request url is: ${requestNeedRetry.options.uri}");
            // requestNeedRetry.options.headers['Authorization'] = 'Bearer $refreshedAccessToken';
            // final cloneReq = await dio.request(
            //   err.requestOptions.path,
            //   options: Options(
            //     method: err.requestOptions.method,
            //     headers: err.requestOptions.headers,
            //   ),
            //   data: err.requestOptions.data,
            //   queryParameters: err.requestOptions.queryParameters,
            // );
            //
            // return handler.resolve(cloneReq);
            requestNeedRetry.options.headers['Authorization'] =
                'Bearer $refreshedAccessToken';
            dio.fetch(requestNeedRetry.options).then((response) {
              requestNeedRetry.handler.resolve(response);
            }).catchError((e) {
              requestNeedRetry.handler.reject(e);
            });
          }
        } else {
          // Handle token refresh failure
          for (var requestNeedRetry in _requestsNeedRetry) {
            requestNeedRetry.handler.reject(err);
          }
        }
        _requestsNeedRetry.clear();
        _isRefreshing = false;
      } else {
        // if refresh flow is processing, add this request to queue and wait to retry later
        _requestsNeedRetry.add((options: err.requestOptions, handler: handler));
      }
    } else {
      // ignore other error is not unauthorized
      return handler.next(err);
    }
    // return handler.next(err);
  }
}
