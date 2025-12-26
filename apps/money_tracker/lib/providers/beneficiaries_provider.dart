import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import 'database_provider.dart';

final beneficiariesProvider = StreamProvider.autoDispose<List<Beneficiary>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return db.select(db.beneficiaries).watch();
});
