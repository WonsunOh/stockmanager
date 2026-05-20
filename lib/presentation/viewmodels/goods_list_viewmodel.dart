import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/material_model.dart';
import '../../data/repositories/material_repository.dart';

final goodsSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final goodsSortColumnIndexProvider = StateProvider.autoDispose<int>((ref) => 1);
final goodsSortAscendingProvider = StateProvider.autoDispose<bool>((ref) => true);

final goodsCategoryFilterProvider =
    StateProvider.autoDispose<String>((ref) => '모든카테고리');

final goodsListViewModelProvider =
    StreamNotifierProvider.autoDispose<GoodsListViewModel, List<MaterialModel>>(
  GoodsListViewModel.new,
);

class GoodsListViewModel extends AutoDisposeStreamNotifier<List<MaterialModel>> {
  @override
  Stream<List<MaterialModel>> build() {
    final category = ref.watch(goodsCategoryFilterProvider);
    final repo = ref.watch(materialRepositoryProvider);

    final baseStream = (category == '모든카테고리')
        ? repo.getMaterialsStream()
        : repo.getMaterialsStreamByCategory(category);

    return baseStream.map((list) {
      final searchQuery = ref.watch(goodsSearchQueryProvider).toLowerCase();
      final sortColumnIndex = ref.watch(goodsSortColumnIndexProvider);
      final sortAscending = ref.watch(goodsSortAscendingProvider);

      final filtered = searchQuery.isEmpty
          ? list
          : list.where((m) {
              final nameMatch = m.name?.toLowerCase().contains(searchQuery) ?? false;
              final codeMatch =
                  m.originalItemNumber?.toLowerCase().contains(searchQuery) ?? false;
              return nameMatch || codeMatch;
            }).toList();

      filtered.sort((a, b) {
        int compare;
        switch (sortColumnIndex) {
          case 1: // 아이템넘버 (original_item_number)
            compare = (a.originalItemNumber ?? '').compareTo(b.originalItemNumber ?? '');
            break;
          case 2: // 상품명 (name)
            compare = (a.name ?? '').compareTo(b.name ?? '');
            break;
          default:
            compare = 0;
        }
        return sortAscending ? compare : -compare;
      });

      return filtered;
    });
  }

  void setCategory(String category) {
    ref.read(goodsCategoryFilterProvider.notifier).state = category;
  }
}
