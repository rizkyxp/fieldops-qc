import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? DioService().client;

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    // Explicitly access 'data' key for login response
    return LoginResponseModel.fromJson(response.data['data']);
  }

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    // Use full response for register to access status_code and message
    return RegisterResponseModel.fromJson(response.data);
  }

  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }
}
