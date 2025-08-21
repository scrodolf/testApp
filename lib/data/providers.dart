import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/app_database.dart';
import 'repositories/product_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductRepository(db);
});
