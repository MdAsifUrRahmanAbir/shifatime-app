import '../../core/services/api_method.dart';
import '../../core/services/app_endpoint.dart';
import '../../core/services/app_snackbar.dart';
import '../../core/utils/app_logger.dart';

/// Profile-level API services — follows Remitium's feature service pattern.
class ProfileApiServices {
  ProfileApiServices._();
  static final _log = appLogger(ProfileApiServices);

  // ── Get Profile ─────────────────────────────────────────────────────────────
  /// GET /user/profile/info   (isBasic: false — requires token)
  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      return await ApiMethod(isBasic: false).get(AppEndpoint.profileGetURL);
    } catch (e) {
      _log.e('🐞 getProfile error: $e');
      AppSnackBar.error('Failed to load profile. Please try again.');
      return null;
    }
  }

  // ── Update Profile ──────────────────────────────────────────────────────────
  /// POST /user/profile/info/update + multipart image upload
  static Future<Map<String, dynamic>?> updateProfile({
    required Map<String, String> body,
    String? imagePath,
  }) async {
    try {
      if (imagePath != null) {
        return await ApiMethod(
          isBasic: false,
        ).multipart(AppEndpoint.profileUpdateURL, body, imagePath, 'image');
      }
      return await ApiMethod(
        isBasic: false,
      ).post(AppEndpoint.profileUpdateURL, body, code: 200);
    } catch (e) {
      _log.e('🐞 updateProfile error: $e');
      AppSnackBar.error('Failed to update profile. Please try again.');
      return null;
    }
  }
}
