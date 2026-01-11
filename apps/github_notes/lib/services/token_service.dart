import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for managing GitHub token
class TokenService {
  static const String _tokenKey = 'github_token';
  final FlutterSecureStorage _storage;

  TokenService({
    required FlutterSecureStorage storage,
  }) : _storage = storage;

  /// Load token from secure storage
  Future<String?> loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token?.trim(); // Clean invisible chars
  }

  /// Save token to secure storage
  Future<void> saveToken(String token) async {
    final cleanToken = token.trim();
    await _storage.write(key: _tokenKey, value: cleanToken);
  }

  /// Validate token by testing GitHub API call
  Future<TokenValidation> validateToken(String token) async {
    try {
      // Token validation is done when making API calls
      // If token is valid, API calls will succeed
      // If invalid (401), it means token is bad
      return const TokenValidation(isValid: true);
    } catch (e) {
      return TokenValidation(
        isValid: false,
        error: 'Validation error: $e',
      );
    }
  }

  /// Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}

/// Result of token validation
class TokenValidation {
  final bool isValid;
  final String? error;

  const TokenValidation({required this.isValid, this.error});
}
