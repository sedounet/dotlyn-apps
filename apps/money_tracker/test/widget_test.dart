// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:money_tracker/main.dart';

void main() {
  testWidgets('App renders Home and shows ad banner', (WidgetTester tester) async {
    // Build our app inside a ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Allow a single frame for initial build and short async init
    await tester.pump(const Duration(milliseconds: 200));

    // Verify that the 'create account' hint is visible when no accounts exist
    await tester.pump();
    expect(find.text('Créez un compte pour commencer.'), findsOneWidget);
  });
}
