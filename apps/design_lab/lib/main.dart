import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'providers/providers.dart';
import 'screens/home_screen.dart';

void main() {
  debugPrint('🚀 Design Lab - App standalone pour tester le Design System');
  runApp(const ProviderScope(child: DesignLabApp()));
}

class DesignLabApp extends ConsumerWidget {
  const DesignLabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeProviderRiverpod);

    return MaterialApp(
      title: 'Design Lab - Dotlyn',
      theme: DotlynTheme.lightTheme,
      darkTheme: DotlynTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
