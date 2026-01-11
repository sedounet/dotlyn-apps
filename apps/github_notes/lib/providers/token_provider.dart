import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_notes/services/token_service.dart';

/// Provider for secure storage singleton
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

/// Provider for TokenService
final tokenServiceProvider = Provider<TokenService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenService(storage: storage);
});

/// Load token from secure storage (FutureProvider for reactivity)
final loadedTokenProvider = FutureProvider<String?>((ref) async {
  final tokenService = ref.watch(tokenServiceProvider);
  return await tokenService.loadToken();
});
