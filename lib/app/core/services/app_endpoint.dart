/// All API endpoints in one place.
/// Pattern: static String fooURL = '/route'.addBaseUrl();
///
/// Usage in ApiServices:
///   ApiMethod(isBasic: true).post(AppEndpoint.loginURL, body);
///   ApiMethod(isBasic: false).get(AppEndpoint.profileURL);
class AppEndpoint {
  AppEndpoint._();

  // ── Domain ──────────────────────────────────────────────────────────────────
  static const String mainDomain =
      'https://fakestoreapi.com'; // <── change per project
  static const String baseUrl = mainDomain;

  // ── Helper ──────────────────────────────────────────────────────────────────
  static String _url(String path) => '$baseUrl$path';

  // ── Settings ─────────────────────────────────────────────────────────────────
  static final String settingsURL = _url('/settings/basic-settings');

  // ── Auth ─────────────────────────────────────────────────────────────────────
  static final String loginURL = _url('/auth/login');
  static final String registerURL = _url('/register');
  static final String logoutURL = _url('/user/logout');
  static final String forgotPasswordURL = _url('/password/forgot/find/user');
  static final String verifyOtpURL = _url('/password/forgot/verify/code');
  static final String resendOtpURL = _url('/password/forgot/resend/code');
  static final String resetPasswordURL = _url('/password/forgot/reset');

  // ── Email Verify ─────────────────────────────────────────────────────────────
  static final String sendVerifyCodeURL = _url('/authorize/mail/send/code');
  static final String resendVerifyCodeURL = _url('/authorize/mail/resend/code');
  static final String verifyCodeURL = _url('/authorize/mail/verify/code');

  // ── Profile ──────────────────────────────────────────────────────────────────
  static final String profileGetURL = _url('/users/1');
  static final String profileUpdateURL = _url('/user/profile/info/update');
  static final String passwordUpdateURL = _url('/user/profile/password/update');
  static final String deleteAccountURL = _url('/user/profile/delete-profile');

  // ── Dashboard ─────────────────────────────────────────────────────────────────
  static final String dashboardURL = _url('/user/dashboard');
  static final String notificationURL = _url('/user/notifications');

  // ── 2FA ──────────────────────────────────────────────────────────────────────
  static final String twoFaGetURL = _url('/user/google-2fa');
  static final String twoFaSubmitURL = _url('/user/google-2fa/status/update');
  static final String twoFaVerifyURL = _url('/authorize/google/2fa/verify');

  // ── Add custom endpoints below as the project grows ─────────────────────────

  static final String fakeProductsGetUrl = _url('/products');
}
