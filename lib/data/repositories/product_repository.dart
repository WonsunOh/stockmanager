import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';
import 'material_repository.dart' show supabaseClientProvider;

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(supabaseClientProvider));
});

class ProductRepository {
  final SupabaseClient _client;
  static const _table = 'products';

  ProductRepository(this._client);

  Stream<List<ProductModel>> getProductsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('id')
        .map((rows) => rows.map(ProductModel.fromMap).toList());
  }

  /// Upsert. `id` set → update; otherwise insert.
  Future<ProductModel> save(ProductModel product) async {
    final payload = product.toMap();
    final response = product.id == null
        ? await _client.from(_table).insert(payload).select().single()
        : await _client.from(_table).update(payload).eq('id', product.id!).select().single();
    return ProductModel.fromMap(response);
  }

  Future<void> delete(int id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
