import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';
import 'session_provider.dart';
import 'gameplay_type_provider.dart';
import 'ship_provider.dart';
import 'resource_provider.dart';

// Re-export legacy ChangeNotifier provider classes so callers importing
// `providers.dart` can reference the underlying provider types.
export 'profile_provider.dart';
export 'session_provider.dart';
export 'gameplay_type_provider.dart';
export 'ship_provider.dart';
export 'resource_provider.dart';

/// Temporary Riverpod wrappers around existing ChangeNotifier providers.
final profileProviderRiverpod = ChangeNotifierProvider<ProfileProvider>((ref) {
  final provider = ProfileProvider();
  provider.loadProfiles();
  return provider;
});

final sessionProviderRiverpod = ChangeNotifierProvider<SessionProvider>((ref) {
  final provider = SessionProvider();
  provider.loadSessions();
  return provider;
});

final gameplayTypeProviderRiverpod =
    ChangeNotifierProvider<GameplayTypeProvider>((ref) {
  final provider = GameplayTypeProvider();
  provider.loadTypes();
  return provider;
});

final shipProviderRiverpod = ChangeNotifierProvider<ShipProvider>((ref) {
  final provider = ShipProvider();
  provider.loadShips();
  return provider;
});

final resourceProviderRiverpod =
    ChangeNotifierProvider<ResourceProvider>((ref) {
  final provider = ResourceProvider();
  provider.loadResources();
  return provider;
});
