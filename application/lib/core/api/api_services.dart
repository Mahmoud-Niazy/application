import 'package:dio/dio.dart';

class ApiServices {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://task.dblentry.com',
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 15),
      ),
    );
  }

  Future<Response> getData({
    required String path,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      "Authorization" : "Bearer $token",
    };
    var response = await dio.get(
      path,
      queryParameters: query,
    );
    return response;
  }

  Future<Response> postData({
    required String path,
    required dynamic data,
    String? token,
  }) async {
    dio.options.headers = {
      "Authorization" : "Bearer $token",
    };
    return await dio.post(
      path,
      data: data,
    );
  }

  Future<Response> patchData({
    required String path,
    required dynamic data,
    String? token,
  }) async {
    dio.options.headers = {
      "Authorization" : "Bearer $token",
    };
    return await dio.patch(
      path,
      data: data,
    );
  }

  Future<Response> putData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(
      path,
      data: data,
    );
  }

  Future<Response> deleteData({
    required String path,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers = {
      "Authorization" : "Bearer $token",
    };
    return await dio.delete(
      path,
      data: data,
    );
  }
}