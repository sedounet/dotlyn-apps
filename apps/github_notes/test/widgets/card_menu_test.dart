import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_notes/l10n/app_localizations.dart';
import 'package:github_notes/widgets/card_menu.dart';

void main() {
  testWidgets('CardMenu shows items and triggers callbacks', (tester) async {
    bool dup = false;
    bool edit = false;

    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: CardMenu(
            actions: [
              CardMenuAction(
                labelBuilder: (ctx) => AppLocalizations.of(ctx)!.duplicate,
                onSelected: () => dup = true,
                icon: Icons.copy,
              ),
              CardMenuAction(
                labelBuilder: (ctx) => AppLocalizations.of(ctx)!.edit,
                onSelected: () => edit = true,
                icon: Icons.edit,
              ),
            ],
          ),
        ),
      ),
    ));

    // Open menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    expect(find.text('Duplicate'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);

    await tester.tap(find.text('Duplicate'));
    await tester.pumpAndSettle();
    expect(dup, true);

    // Re-open to trigger edit
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(edit, true);
  });
}
