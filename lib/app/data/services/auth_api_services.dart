import '../../core/services/api_method.dart';
import '../../core/services/app_endpoint.dart';
import '../../core/services/app_snackbar.dart';
import '../../core/utils/app_logger.dart';

class AuthApiServices {
  AuthApiServices._();
  static final _log = appLogger(AuthApiServices);

  // ── Sign In ────────────────────────────────────────────────────────────────
  /// POST /login   (isBasic: true — no auth token required)
  static Future<Map<String, dynamic>?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await ApiMethod(isBasic: true).post(
        AppEndpoint.loginURL,
        {'email': email, 'password': password},
        code: 200,
        showResult: true,
      );
    } catch (e) {
      _log.e('🐞 signIn error: $e');
      AppSnackBar.error('Sign in failed. Please try again.');
      return null;
    }
  }

  // ── Sign Up ────────────────────────────────────────────────────────────────
  /// POST /register   (isBasic: true)
  static Future<Map<String, dynamic>?> signUp({
    required Map<String, dynamic> body,
  }) async {
    try {
      return await ApiMethod(
        isBasic: true,
      ).post(AppEndpoint.registerURL, body, code: 200);
    } catch (e) {
      _log.e('🐞 signUp error: $e');
      AppSnackBar.error('Registration failed. Please try again.');
      return null;
    }
  }

  // ── Forgot Password ────────────────────────────────────────────────────────
  /// POST /password/forgot/find/user   (isBasic: true)
  static Future<Map<String, dynamic>?> forgotPassword({
    required String email,
  }) async {
    try {
      return await ApiMethod(
        isBasic: true,
      ).post(AppEndpoint.forgotPasswordURL, {'email': email}, code: 200);
    } catch (e) {
      _log.e('🐞 forgotPassword error: $e');
      AppSnackBar.error('Something went wrong. Please try again.');
      return null;
    }
  }

  // ── Verify Reset OTP ────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> verifyResetOtp({
    required Map<String, dynamic> body,
  }) async {
    try {
      return await ApiMethod(
        isBasic: true,
      ).post(AppEndpoint.verifyOtpURL, body, code: 200);
    } catch (e) {
      _log.e('🐞 verifyResetOtp error: $e');
      AppSnackBar.error('OTP verification failed.');
      return null;
    }
  }

  // ── Reset Password ──────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> resetPassword({
    required Map<String, dynamic> body,
  }) async {
    try {
      return await ApiMethod(
        isBasic: true,
      ).post(AppEndpoint.resetPasswordURL, body, code: 200);
    } catch (e) {
      _log.e('🐞 resetPassword error: $e');
      AppSnackBar.error('Password reset failed. Please try again.');
      return null;
    }
  }

  // ── Change Password (authenticated) ────────────────────────────────────────
  static Future<Map<String, dynamic>?> changePassword({
    required Map<String, dynamic> body,
  }) async {
    try {
      return await ApiMethod(
        isBasic: false,
      ).post(AppEndpoint.passwordUpdateURL, body, code: 200);
    } catch (e) {
      _log.e('🐞 changePassword error: $e');
      AppSnackBar.error('Password update failed. Please try again.');
      return null;
    }
  }

  // ── Logout ──────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> logout() async {
    try {
      return await ApiMethod(
        isBasic: false,
      ).post(AppEndpoint.logoutURL, {}, code: 200);
    } catch (e) {
      _log.e('🐞 logout error: $e');
      return null;
    }
  }
}
