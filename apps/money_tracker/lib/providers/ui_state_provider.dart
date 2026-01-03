import 'package:flutter_riverpod/flutter_riverpod.dart';

final balanceVisibilityProvider =
    StateNotifierProvider<BalanceVisibilityNotifier, bool>(
  (ref) => BalanceVisibilityNotifier(),
);

class BalanceVisibilityNotifier extends StateNotifier<bool> {
  BalanceVisibilityNotifier() : super(false);

  void toggleVisibility() => state = !state;
}
