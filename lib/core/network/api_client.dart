import 'package:dio/dio.dart';
import '../config/env.dart';
import 'api_constants.dart';

class ApiClient {
  static Dio? _groqDio;
  static Dio? _indianKanoonDio;

  static Dio get groq {
    _groqDio ??= Dio(
      BaseOptions(
        baseUrl: ApiConstants.groqBase,
        headers: {
          'Authorization': 'Bearer ${Env.groqApiKey}',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    )..interceptors.add(_LogInterceptor('Groq'));
    return _groqDio!;
  }

  static Dio get indianKanoon {
    _indianKanoonDio ??= Dio(
      BaseOptions(
        baseUrl: ApiConstants.indianKanoonBase,
        headers: {
          'Authorization': 'Token ${Env.indianKanoonToken}',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    )..interceptors.add(_LogInterceptor('IndianKanoon'));
    return _indianKanoonDio!;
  }
}

class _LogInterceptor extends Interceptor {
  final String name;
  _LogInterceptor(this.name);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log errors in debug builds only
    assert(() {
      // ignore: avoid_print
      print('[$name] Error ${err.response?.statusCode}: ${err.message}');
      return true;
    }());
    handler.next(err);
  }
}
