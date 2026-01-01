import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';
import 'package:github_notes/screens/files_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: GitHubNotesApp()));
}

class GitHubNotesApp extends StatelessWidget {
  const GitHubNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Notes',
      theme: DotlynTheme.lightTheme,
      home: const FilesListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
