import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (options.path.contains(ApiEndpoints.login)) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {"token": "mock-access-token-12345"},
        ),
      );
      return;
    }

    if (options.path.contains(ApiEndpoints.register)) {
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            "status_code": 200,
            "message": "Registration Successful (Mock)",
          },
        ),
      );
      return;
    }

    // Pass through if not mocked (or reject if strict mode desired)
    // For now, let's just reject known paths appropriately or pass
    // but here we intend to mock specifically known endpoints.
    super.onRequest(options, handler);
  }
}
