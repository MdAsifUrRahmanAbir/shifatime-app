import '../utils/app_logger.dart';
import 'api_method.dart';
import 'app_snackbar.dart';

final _log = appLogger(ApiServices);

/// Generic API service that parses HTTP responses into typed models.
///
/// Pattern (Remitium-style):
///   final result = await ApiServices.get<DashboardModel>(
///     DashboardModel.fromJson,
///     AppEndpoint.dashboardURL,
///   );
///
///   final result = await ApiServices.post<SignInModel>(
///     SignInModel.fromJson,
///     AppEndpoint.loginURL,
///     body: {'email': 'a@b.com', 'password': '123'},
///     isBasic: true,
///     showResult: true,
///   );
class ApiServices {
  ApiServices._();

  // ── GET ─────────────────────────────────────────────────────────────────────
  static Future<T?> get<T>(
    T Function(Map<String, dynamic>) fromJson,
    String url, {
    bool isBasic = false,
    bool showResult = false,
    bool showErrorMessage = true,
    bool showSuccessMessage = false,
  }) async {
    try {
      final response = await ApiMethod(
        isBasic: isBasic,
      ).get(url, showResult: showResult, showErrorMessage: showErrorMessage);
      if (response != null) {
        return _handleSuccess(response, fromJson, showSuccessMessage);
      }
    } catch (e) {
      _log.e('🐞 ApiServices.get error on $url: $e');
      AppSnackBar.error('Something went wrong.');
    }
    return null;
  }

  // ── POST ────────────────────────────────────────────────────────────────────
  static Future<T?> post<T>(
    T Function(Map<String, dynamic>) fromJson,
    String url, {
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool showResult = false,
    bool showErrorMessage = true,
    bool showSuccessMessage = false,
    int statusCode = 200,
  }) async {
    try {
      final response = await ApiMethod(isBasic: isBasic).post(
        url,
        body ?? {},
        code: statusCode,
        showResult: showResult,
        showErrorMessage: showErrorMessage,
      );
      if (response != null) {
        return _handleSuccess(response, fromJson, showSuccessMessage);
      }
    } catch (e) {
      _log.e('🐞 ApiServices.post error on $url: $e');
      AppSnackBar.error('Something went wrong.');
    }
    return null;
  }

  // ── MULTIPART (multi-file) ───────────────────────────────────────────────────
  static Future<T?> multipart<T>(
    T Function(Map<String, dynamic>) fromJson,
    String url,
    Map<String, String> body, {
    required List<String> fieldList,
    required List<String> pathList,
    bool isBasic = false,
    bool showErrorMessage = true,
    bool showSuccessMessage = false,
  }) async {
    try {
      final response = await ApiMethod(isBasic: isBasic).multipartMultiFile(
        url,
        body,
        fieldList: fieldList,
        pathList: pathList,
        showErrorMessage: showErrorMessage,
      );
      if (response != null) {
        return _handleSuccess(response, fromJson, showSuccessMessage);
      }
    } catch (e) {
      _log.e('🐞 ApiServices.multipart error on $url: $e');
      AppSnackBar.error('Something went wrong.');
    }
    return null;
  }

  // ── Helper ───────────────────────────────────────────────────────────────────
  static T? _handleSuccess<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
    bool showSuccessMessage,
  ) {
    final result = fromJson(response);
    if (showSuccessMessage) {
      try {
        final msgList = response['message']?['success'] as List?;
        final msg = msgList?.first?.toString() ?? 'Success';
        AppSnackBar.success(msg);
      } catch (_) {
        AppSnackBar.success('Success');
      }
    }
    return result;
  }
}
