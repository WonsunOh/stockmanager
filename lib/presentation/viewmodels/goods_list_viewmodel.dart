import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/material_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/material_repository.dart';

final goodsSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final goodsSortColumnIndexProvider = StateProvider.autoDispose<int>((ref) => 1);
final goodsSortAscendingProvider = StateProvider.autoDispose<bool>((ref) => true);

/// Selected category id from the cascading filter. `null` = 전체.
final goodsCategoryFilterIdProvider =
    StateProvider.autoDispose<int?>((ref) => null);

final goodsListViewModelProvider =
    StreamNotifierProvider.autoDispose<GoodsListViewModel, List<MaterialModel>>(
  GoodsListViewModel.new,
);

class GoodsListViewModel extends AutoDisposeStreamNotifier<List<MaterialModel>> {
  @override
  Stream<List<MaterialModel>> build() {
    final repo = ref.watch(materialRepositoryProvider);
    final filterId = ref.watch(goodsCategoryFilterIdProvider);
    final treeAsync = ref.watch(categoryTreeProvider);
    final allowedIds = filterId == null
        ? null
        : treeAsync.maybeWhen(
            data: (tree) => tree.descendantIdsInclusive(filterId),
            orElse: () => <int>{filterId},
          );

    return repo.getMaterialsStream().map((list) {
      final searchQuery = ref.watch(goodsSearchQueryProvider).toLowerCase();
      final sortColumnIndex = ref.watch(goodsSortColumnIndexProvider);
      final sortAscending = ref.watch(goodsSortAscendingProvider);

      final filtered = list.where((m) {
        if (allowedIds != null) {
          if (m.categoryId == null || !allowedIds.contains(m.categoryId)) {
            return false;
          }
        }
        if (searchQuery.isEmpty) return true;
        final nameMatch = m.name?.toLowerCase().contains(searchQuery) ?? false;
        final codeMatch =
            m.originalItemNumber?.toLowerCase().contains(searchQuery) ?? false;
        return nameMatch || codeMatch;
      }).toList();

      filtered.sort((a, b) {
        int compare;
        switch (sortColumnIndex) {
          case 1: // 아이템넘버
            compare = (a.originalItemNumber ?? '').compareTo(b.originalItemNumber ?? '');
            break;
          case 2: // 상품명
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
}
