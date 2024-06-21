// services/api_services.dart

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tasky/core/config/config.dart';
import 'package:tasky/core/network/refresh_access_token_response_model.dart';
import 'package:tasky/core/network/token_interceptor.dart';
import 'package:tasky/features/auth/data/models/login_model.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tasky/features/task/data/models/upload_image_response_model.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: EndPoints.host)
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @GET(EndPoints.profile)
  Future<ProfileModel> getProfile();

  @POST(EndPoints.login)
  Future<LoginModel> login(@Body() Map<String, dynamic> userData);

  @POST(EndPoints.register)
  Future<LoginModel> register(@Body() Map<String, dynamic> userData);

  @POST(EndPoints.logout)
  Future<Map<String, bool>> logout(@Header('Authorization') String token,
      @Body() Map<String, String> refreshToken);

  @GET(EndPoints.refreshToken)
  Future<RefreshAccessTokenResponseModel> refreshAccessToken(
      @Query("token") String token);

  @GET(EndPoints.tasks)
  Future<List<TaskModel>> getListOfTasks(@Query("page") int page);

  @DELETE("${EndPoints.tasks}{id}")
  Future deleteTask(@Path("id") tokenId);

  @PUT("${EndPoints.tasks}{id}")
  Future<TaskModel> editTask(
      @Path("id") tokenId, @Body() Map<String, dynamic> tokenData);

  @GET("${EndPoints.tasks}{id}")
  Future<TaskModel> getTask(@Path("id") taskId);

  @POST(EndPoints.tasks)
  Future<TaskModel> addNewTask(@Body() Map<String, dynamic> task);

  @POST(EndPoints.uploadImage)
  @MultiPart()
  Future<UploadImageResponseModel> uploadImage(
      @Part(name: "image", contentType: "image/*")
      File file); //contentType: MediaType.parse("image/*"),
}

class ApiClient {
  late Dio dio;
  late ApiServices apiService;

  ApiClient() {
    dio = Dio();
    dio
      ..interceptors.add(
        PrettyDioLogger(
          responseBody: true,
          responseHeader: true,
          requestBody: true,
          requestHeader: true,
        ),
      ) ..interceptors.add(TokenInterceptor(dio));
      // ..interceptors.add(
      //   InterceptorsWrapper(
      //     onRequest: (options, handler) async {
      //       // Add authorization header
      //       final tokenService = getx.Get.find<TokenService>();
      //       final token = await tokenService.getAccessToken();
      //       options.headers['Authorization'] = 'Bearer $token';
      //       // if (options.path.contains('/upload/image')) {
      //       //   options.headers['Content-Type'] = 'multipart/form-data';
      //       // }
      //       return handler.next(options);
      //     },
      //     onError: (DioException error, ErrorInterceptorHandler handler) async {
      //
      //       if (error.response?.statusCode == 401) {
      //         final refreshedAccessToken = await getx.Get.find<AuthController>().refreshToken();
      //
      //         if (refreshedAccessToken != null) {
      //           error.requestOptions.headers['Authorization'] = 'Bearer $refreshedAccessToken';
      //           // Retry the failed request
      //           final cloneReq = await dio.request(
      //             error.requestOptions.path,
      //             options: Options(
      //               method: error.requestOptions.method,
      //               headers: error.requestOptions.headers,
      //             ),
      //             data: error.requestOptions.data,
      //             queryParameters: error.requestOptions.queryParameters,
      //           );
      //           // Repeat the request with the updated header
      //           return handler.resolve(await dio.fetch(error.requestOptions));
      //           // return handler.resolve(cloneReq);
      //         }
      //       }
      //       return handler.next(error);
      //     },
      //   ),
      // );
    apiService = ApiServices(dio);
  }
}
