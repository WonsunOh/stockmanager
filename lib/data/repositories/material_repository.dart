import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/material_model.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return MaterialRepository(ref.watch(supabaseClientProvider));
});

class MaterialRepository {
  final SupabaseClient _client;
  static const _table = 'materials';

  MaterialRepository(this._client);

  Stream<List<MaterialModel>> getMaterialsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('id')
        .map((rows) => rows.map(MaterialModel.fromMap).toList());
  }

  Stream<List<MaterialModel>> getMaterialsStreamByCategory(String category) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('firebase_category', category)
        .order('id')
        .map((rows) => rows.map(MaterialModel.fromMap).toList());
  }

  /// Upsert. If `id` is set → update; otherwise insert (new row).
  Future<MaterialModel> save(MaterialModel material) async {
    final payload = material.toMap();
    final response = material.id == null
        ? await _client.from(_table).insert(payload).select().single()
        : await _client.from(_table).update(payload).eq('id', material.id!).select().single();
    return MaterialModel.fromMap(response);
  }

  Future<void> delete(int id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
