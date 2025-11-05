import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:dotlyn_core/dotlyn_core.dart';
import 'screens/home_screen.dart';

void main() {
  debugPrint('🚀 Design Lab - App standalone pour tester le Design System');
  runApp(const DesignLabApp());
}

class DesignLabApp extends StatelessWidget {
  const DesignLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Design Lab - Dotlyn',
            theme: DotlynTheme.lightTheme,
            darkTheme: DotlynTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
