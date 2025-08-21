import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/repositories/goods_repository.dart';

import '../../data/models/goods_firebase_model.dart';

// --- 1. 검색과 정렬 상태를 관리할 Provider들을 새로 추가합니다. ---
final goodsSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');
final goodsSortColumnIndexProvider = StateProvider.autoDispose<int>((ref) => 1); // 1: 아이템넘버 기준 기본 정렬
final goodsSortAscendingProvider = StateProvider.autoDispose<bool>((ref) => true);
// ---------------------------------------------------------

// 현재 선택된 카테고리를 관리하는 간단한 Provider
final goodsCategoryFilterProvider = StateProvider.autoDispose<String>((ref) => '모든카테고리');

// 1. Provider를 StreamNotifierProvider로 변경
final goodsListViewModelProvider =
    StreamNotifierProvider.autoDispose<GoodsListViewModel, List<GoodsFirebaseModel>>(
  GoodsListViewModel.new,
);

// 2. Notifier를 AutoDisposeStreamNotifier로 변경
class GoodsListViewModel extends AutoDisposeStreamNotifier<List<GoodsFirebaseModel>> {
  @override
  Stream<List<GoodsFirebaseModel>> build() {
    final category = ref.watch(goodsCategoryFilterProvider);
    final goodsRepository = ref.watch(goodsRepositoryProvider);

    // 카테고리에 맞는 기본 데이터 스트림을 가져옵니다.
    final baseStream = (category == '모든카테고리')
        ? goodsRepository.getGoodsStream()
        : goodsRepository.getGoodsStreamByCategory(category);
    
    // --- 2. 가져온 스트림에 검색 및 정렬 로직을 적용합니다. ---
    return baseStream.map((goodsList) {
      // 현재 검색어와 정렬 상태를 가져옵니다.
      final searchQuery = ref.watch(goodsSearchQueryProvider).toLowerCase();
      final sortColumnIndex = ref.watch(goodsSortColumnIndexProvider);
      final sortAscending = ref.watch(goodsSortAscendingProvider);

      // 검색어 필터링
      final filteredList = searchQuery.isEmpty
          ? goodsList
          : goodsList.where((goods) {
              final titleMatch = goods.title?.toLowerCase().contains(searchQuery) ?? false;
              final itemNumberMatch = goods.itemNumber?.toLowerCase().contains(searchQuery) ?? false;
              return titleMatch || itemNumberMatch;
            }).toList();

      // 정렬
      filteredList.sort((a, b) {
        int compare;
        switch (sortColumnIndex) {
          case 1: // 아이템넘버
            compare = (a.itemNumber ?? '').compareTo(b.itemNumber ?? '');
            break;
          case 2: // 상품명
            compare = (a.title ?? '').compareTo(b.title ?? '');
            break;
          default:
            compare = 0;
        }
        return sortAscending ? compare : -compare;
      });

      return filteredList;
    });
  }

  void setCategory(String category) {
    ref.read(goodsCategoryFilterProvider.notifier).state = category;
  }
}