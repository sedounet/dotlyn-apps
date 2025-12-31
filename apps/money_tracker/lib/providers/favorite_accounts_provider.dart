import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import 'database_provider.dart';

// Watch all favorite accounts (ordered by buttonIndex)
final favoriteAccountsProvider =
    StreamProvider.autoDispose<List<FavoriteAccount>>((ref) {
      final database = ref.watch(databaseProvider);
      return (database.select(
        database.favoriteAccounts,
      )..orderBy([(t) => OrderingTerm(expression: t.buttonIndex)])).watch();
    });

final favoriteAccountsRepositoryProvider = Provider<FavoriteAccountsRepository>(
  (ref) {
    final database = ref.watch(databaseProvider);
    return FavoriteAccountsRepository(database);
  },
);

/// Provides the favorite account for a specific button index (0-3)
final favoriteAccountByIndexProvider = StreamProvider.autoDispose
    .family<FavoriteAccount?, int>((ref, buttonIndex) {
      final database = ref.watch(databaseProvider);
      return (database.select(
        database.favoriteAccounts,
      )..where((f) => f.buttonIndex.equals(buttonIndex))).watchSingleOrNull();
    });

class FavoriteAccountsRepository {
  FavoriteAccountsRepository(this._database);

  final AppDatabase _database;

  /// Assign or update a favorite account at the given button index
  Future<void> assignFavorite({
    required int buttonIndex,
    required int accountId,
  }) async {
    // Check if this button index already has a favorite
    final existing = await (_database.select(
      _database.favoriteAccounts,
    )..where((f) => f.buttonIndex.equals(buttonIndex))).getSingleOrNull();

    if (existing != null) {
      // Update existing
      await (_database.update(_database.favoriteAccounts)
            ..where((f) => f.buttonIndex.equals(buttonIndex)))
          .write(FavoriteAccountsCompanion(accountId: Value(accountId)));
    } else {
      // Insert new
      await _database
          .into(_database.favoriteAccounts)
          .insert(
            FavoriteAccountsCompanion(
              buttonIndex: Value(buttonIndex),
              accountId: Value(accountId),
            ),
          );
    }
  }

  /// Remove a favorite account from a button index
  Future<void> removeFavorite(int buttonIndex) {
    return (_database.delete(
      _database.favoriteAccounts,
    )..where((f) => f.buttonIndex.equals(buttonIndex))).go();
  }

  /// Clear all favorite accounts
  Future<void> clearAll() {
    return _database.delete(_database.favoriteAccounts).go();
  }
}
