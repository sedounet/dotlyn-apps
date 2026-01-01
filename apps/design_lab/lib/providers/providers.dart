export 'package:dotlyn_core/dotlyn_core.dart' show ThemeProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_core/dotlyn_core.dart' show ThemeProvider;

// Riverpod wrapper exposing the existing ChangeNotifier ThemeProvider
final themeProviderRiverpod = ChangeNotifierProvider<ThemeProvider>((ref) {
  return ThemeProvider();
});
