import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_notes/widgets/project_file_form.dart';

void main() {
  testWidgets('validation shows errors when fields empty', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () => showDialog(
              context: context, builder: (_) => const AlertDialog(content: ProjectFileForm())),
          child: const Text('open'),
        );
      },
    )));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Tap add without filling fields
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter owner'), findsOneWidget);
    expect(find.text('Please enter repository'), findsOneWidget);
    expect(find.text('Please enter file path'), findsOneWidget);
    expect(find.text('Please enter a nickname'), findsOneWidget);
  });

  testWidgets('submits when valid', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () => showDialog(
              context: context, builder: (_) => const AlertDialog(content: ProjectFileForm())),
          child: const Text('open'),
        );
      },
    )));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Owner'), 'sedounet');
    await tester.enterText(find.widgetWithText(TextFormField, 'Repository'), 'dotlyn-apps');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'File Path'), '_docs/apps/money_tracker/PROMPT_USER.md');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nickname'), 'Money Tracker - User Prompt');

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Dialog should be dismissed
    expect(find.byType(AlertDialog), findsNothing);
  });
}
