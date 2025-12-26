import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic>) {
      final json = response.data as Map<String, dynamic>;

      // Check if it's the standard envelope
      if (json.containsKey('data') && json.containsKey('status_code')) {
        // Unwrap: Replace the response data with the inner 'data'
        response.data = json['data'];
      }
    }
    super.onResponse(response, handler);
  }
}
