import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Network client configuration for API calls
class NetworkClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  NetworkClient({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _setupDio();
  }

  void _setupDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: int.parse(AppConstants.apiTimeout)),
        receiveTimeout: Duration(seconds: int.parse(AppConstants.apiTimeout)),
        sendTimeout: Duration(seconds: int.parse(AppConstants.apiTimeout)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    // Request interceptor for adding authentication token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(
            key: AppConstants.accessTokenKey,
          );
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, try to refresh
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              final clonedRequest = await _retryRequest(error.requestOptions);
              handler.resolve(clonedRequest);
              return;
            }
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor (only in debug mode)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await _secureStorage.write(
          key: AppConstants.accessTokenKey,
          value: newAccessToken,
        );
        await _secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: newRefreshToken,
        );

        return true;
      }
    } catch (e) {
      // Refresh failed, user needs to login again
      await _clearTokens();
    }
    return false;
  }

  Future<Response<T>> _retryRequest<T>(RequestOptions requestOptions) async {
    final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
    requestOptions.headers['Authorization'] = 'Bearer $token';
    return _dio.request<T>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handle Dio exceptions and convert to app exceptions
  Exception _handleDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final message =
            dioException.response?.data?['message'] ??
            _getDefaultErrorMessage(statusCode);

        if (statusCode == 401) {
          return AuthException(message: message, code: statusCode);
        } else if (statusCode != null &&
            statusCode >= 400 &&
            statusCode < 500) {
          return ValidationException(message: message, code: statusCode);
        } else {
          return ServerException(message: message, code: statusCode);
        }
      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled',
          code: 499,
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message:
              'No internet connection. Please check your network settings.',
          code: 503,
        );
      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Certificate verification failed',
          code: 495,
        );
      case DioExceptionType.unknown:
        return NetworkException(
          message: dioException.message ?? 'An unexpected error occurred',
          code: 500,
        );
    }
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation failed. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Get Dio instance for custom usage
  Dio get dio => _dio;
}
