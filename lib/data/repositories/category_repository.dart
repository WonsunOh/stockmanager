import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import 'material_repository.dart' show supabaseClientProvider;

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(supabaseClientProvider));
});

/// Categories rarely change, so we fetch once and keep them in memory.
/// AutoDispose intentionally omitted so the tree survives navigation.
final categoryTreeProvider = FutureProvider<CategoryTree>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.fetchTree();
});

class CategoryRepository {
  final SupabaseClient _client;
  static const _table = 'categories';

  CategoryRepository(this._client);

  Future<CategoryTree> fetchTree() async {
    final rows = await _client
        .from(_table)
        .select('id, name, parent_id')
        .order('parent_id', nullsFirst: true)
        .order('id');
    final list = (rows as List)
        .cast<Map<String, dynamic>>()
        .map(CategoryModel.fromMap)
        .toList();
    return CategoryTree.fromList(list);
  }
}
