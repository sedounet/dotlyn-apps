import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:dotlyn_core/dotlyn_core.dart';

import 'l10n/app_localizations.dart';
import 'screens/files_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GitHubNotesApp()));
}

class GitHubNotesApp extends ConsumerWidget {
  const GitHubNotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'GitHub Notes',
      theme: DotlynTheme.lightTheme,
      darkTheme: DotlynTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FilesListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
