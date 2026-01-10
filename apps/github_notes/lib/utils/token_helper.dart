/// Token and credential helpers
class TokenHelper {
  /// Sanitize GitHub token: trim, remove whitespace, zero-width spaces
  static String sanitizeToken(String token) {
    var cleaned = token.trim();
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), '');
    cleaned = cleaned.replaceAll('\u200B', '');
    return cleaned;
  }

  /// Validate token format (basic check: non-empty, reasonable length)
  static bool isTokenValid(String token) {
    final cleaned = sanitizeToken(token);
    return cleaned.isNotEmpty && cleaned.length > 10;
  }
}
