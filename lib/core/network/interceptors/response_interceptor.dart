import 'package:dio/dio.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Global unwrapping removed to handle response structure explicitly in Data Sources
    super.onResponse(response, handler);
  }
}
