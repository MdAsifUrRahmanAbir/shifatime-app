import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../utils/app_logger.dart';
import '../../../app/routes/app_pages.dart';
import 'local_storage_service.dart';
import 'app_snackbar.dart';

final _log = appLogger(ApiMethod);

/// Returns headers for public (unauthenticated) requests.
Map<String, String> _basicHeaders() => {
  HttpHeaders.acceptHeader: 'application/json',
  HttpHeaders.contentTypeHeader: 'application/json',
};

/// Returns headers with Bearer token for authenticated requests.
Future<Map<String, String>> _bearerHeaders() async {
  final token = LocalStorage.getToken();
  return {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
}

/// Low-level HTTP wrapper.
///
/// Usage:
///   final res = await ApiMethod(isBasic: true).post(url, body, code: 200);
///   final res = await ApiMethod(isBasic: false).get(url);
class ApiMethod {
  final bool isBasic;
  const ApiMethod({required this.isBasic});

  // ── GET ────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> get(
    String url, {
    int code = 200,
    int duration = 120,
    bool showResult = false,
    bool showErrorMessage = true,
  }) async {
    _log.i('|📍 GET $url');
    try {
      final res = await http
          .get(
            Uri.parse(url),
            headers: isBasic ? _basicHeaders() : await _bearerHeaders(),
          )
          .timeout(Duration(seconds: duration));
      _log.i('|📒 GET ${res.statusCode}');
      if (showResult) _log.i(res.body);
      return _handleResponse(res, code, showErrorMessage);
    } on SocketException {
      _log.e('SocketException on GET $url');
      if (showErrorMessage) {
        AppSnackBar.error('Check your internet connection and try again.');
      }
      return null;
    } on TimeoutException {
      _log.e('TimeoutException on GET $url');
      if (showErrorMessage) {
        AppSnackBar.error('Request timed out. Please try again.');
      }
      return null;
    } catch (e) {
      _log.e('Unknown error on GET $url: $e');
      return null;
    }
  }

  // ── POST ───────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> post(
    String url,
    Map<String, dynamic> body, {
    int code = 200,
    int duration = 120,
    bool showResult = false,
    bool showErrorMessage = true,
  }) async {
    _log.i('|📍 POST $url | body: $body');
    try {
      final res = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: isBasic ? _basicHeaders() : await _bearerHeaders(),
          )
          .timeout(Duration(seconds: duration));
      _log.i('|📒 POST ${res.statusCode}');
      if (showResult) _log.i(res.body);
      return _handleResponse(res, code, showErrorMessage);
    } on SocketException {
      _log.e('SocketException on POST $url');
      if (showErrorMessage) {
        AppSnackBar.error('Check your internet connection and try again.');
      }
      return null;
    } on TimeoutException {
      _log.e('TimeoutException on POST $url');
      if (showErrorMessage) {
        AppSnackBar.error('Request timed out. Please try again.');
      }
      return null;
    } catch (e) {
      _log.e('Unknown error on POST $url: $e');
      return null;
    }
  }

  // ── MULTIPART (single file) ────────────────────────────────────────────────
  Future<Map<String, dynamic>?> multipart(
    String url,
    Map<String, String> body,
    String filePath,
    String fieldName, {
    int code = 200,
    bool showErrorMessage = true,
  }) async {
    _log.i('|📍 MULTIPART $url');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(body)
        ..headers.addAll(isBasic ? _basicHeaders() : await _bearerHeaders())
        ..files.add(await http.MultipartFile.fromPath(fieldName, filePath));
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      _log.i('|📒 MULTIPART ${res.statusCode}');
      return _handleResponse(res, code, showErrorMessage);
    } on SocketException {
      _log.e('SocketException on MULTIPART $url');
      if (showErrorMessage) {
        AppSnackBar.error('Check your internet connection and try again.');
      }
      return null;
    } catch (e) {
      _log.e('Unknown error on MULTIPART $url: $e');
      return null;
    }
  }

  // ── MULTIPART (multiple files) ─────────────────────────────────────────────
  Future<Map<String, dynamic>?> multipartMultiFile(
    String url,
    Map<String, String> body, {
    required List<String> pathList,
    required List<String> fieldList,
    int code = 200,
    bool showErrorMessage = true,
  }) async {
    _log.i('|📍 MULTIPART-MULTI $url');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(body)
        ..headers.addAll(isBasic ? _basicHeaders() : await _bearerHeaders());
      for (int i = 0; i < fieldList.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(fieldList[i], pathList[i]),
        );
      }
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      _log.i('|📒 MULTIPART-MULTI ${res.statusCode}');
      return _handleResponse(res, code, showErrorMessage);
    } on SocketException {
      _log.e('SocketException on MULTIPART-MULTI $url');
      if (showErrorMessage) {
        AppSnackBar.error('Check your internet connection and try again.');
      }
      return null;
    } catch (e) {
      _log.e('Unknown error on MULTIPART-MULTI $url: $e');
      return null;
    }
  }

  // ── Response Handler ───────────────────────────────────────────────────────
  Map<String, dynamic>? _handleResponse(
    http.Response res,
    int expectedCode,
    bool showErrorMessage,
  ) {
    // Unauthenticated — clear auth and go to login if token exists (expired)
    if (res.statusCode == 401) {
      if (LocalStorage.hasToken()) {
        LocalStorage.signOut();
        Get.offAllNamed(Routes.login);
        return null;
      }
      // If no token, it's likely a login attempt failed — continue to error handling below
    }
    // Server error
    if (res.statusCode == 500) {
      if (showErrorMessage) {
        AppSnackBar.error('Internal server error. Please try again later.');
      }
      return null;
    }
    if (res.statusCode == expectedCode) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    // Other errors — show backend message if available
    _log.e('🐞 Unexpected status ${res.statusCode}: ${res.body}');
    if (showErrorMessage) {
      try {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final msgList = decoded['message']?['error'] as List?;
        final msg =
            msgList?.join(' ') ??
            decoded['message']?.toString() ??
            decoded['msg']?.toString() ?? // Some APIs use 'msg'
            'Something went wrong.';
        AppSnackBar.error(msg);
      } catch (_) {
        AppSnackBar.error('Something went wrong.');
      }
    }
    return null;
  }
}
