import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubApiException implements Exception {
  final String message;
  final int? statusCode;

  GitHubApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'GitHubApiException: $message (status: $statusCode)';
}

class GitHubFileResponse {
  final String content; // Base64 decoded content
  final String sha; // GitHub SHA for conflict detection

  GitHubFileResponse({required this.content, required this.sha});
}

class GitHubService {
  final String? token;
  static const String baseUrl = 'https://api.github.com';

  GitHubService({this.token});

  Map<String, String> get _headers => {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'GitHubNotes-Flutter-App',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Fetch file content from GitHub
  /// Returns decoded content + SHA
  Future<GitHubFileResponse> fetchFile({
    required String owner,
    required String repo,
    required String path,
  }) async {
    final url = Uri.parse('$baseUrl/repos/$owner/$repo/contents/$path');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final contentBase64 = json['content'] as String;
      final sha = json['sha'] as String;

      // Decode base64 content
      final contentDecoded = utf8.decode(base64Decode(
        contentBase64.replaceAll('\n', ''), // Remove newlines from base64
      ));

      return GitHubFileResponse(content: contentDecoded, sha: sha);
    } else if (response.statusCode == 404) {
      throw GitHubApiException('File not found: $path', 404);
    } else if (response.statusCode == 401) {
      throw GitHubApiException('Unauthorized. Check your GitHub token.', 401);
    } else {
      throw GitHubApiException(
        'Failed to fetch file: ${response.body}',
        response.statusCode,
      );
    }
  }

  /// Update file on GitHub
  /// Requires SHA of current file (for conflict detection)
  Future<String> updateFile({
    required String owner,
    required String repo,
    required String path,
    required String content,
    required String sha,
    String message = 'Update from GitHub Notes app',
  }) async {
    final url = Uri.parse('$baseUrl/repos/$owner/$repo/contents/$path');

    final body = jsonEncode({
      'message': message,
      'content': base64Encode(utf8.encode(content)),
      'sha': sha,
    });

    final response = await http.put(
      url,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final newSha = json['content']['sha'] as String;
      return newSha;
    } else if (response.statusCode == 409) {
      throw GitHubApiException(
        'Conflict: File was modified on GitHub. Pull latest changes first.',
        409,
      );
    } else if (response.statusCode == 401) {
      throw GitHubApiException('Unauthorized. Check your GitHub token.', 401);
    } else {
      throw GitHubApiException(
        'Failed to update file: ${response.body}',
        response.statusCode,
      );
    }
  }

  /// Test if token is valid by calling /user endpoint
  Future<bool> testToken() async {
    if (token == null) return false;

    try {
      final url = Uri.parse('$baseUrl/user');
      final response = await http.get(url, headers: _headers);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
