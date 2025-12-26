import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository({AuthRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? AuthRemoteDataSource();

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequestModel(email: email, password: password);
      return await _dataSource.login(request);
    } catch (e) {
      // Handle or rethrow as a custom Failure class
      rethrow;
    }
  }

  Future<RegisterResponseModel> register({
    required String companyName,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequestModel(
        companyName: companyName,
        name: name,
        email: email,
        password: password,
      );
      return await _dataSource.register(request);
    } catch (e) {
      rethrow;
    }
  }
}
