import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/repositories/goods_repository.dart';

import '../../data/models/goods_firebase_model.dart';


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

    if (category == '모든카테고리') {
      return goodsRepository.getGoodsStream();
    } else {
      return goodsRepository.getGoodsStreamByCategory(category);
    }
  }

  void setCategory(String category) {
    ref.read(goodsCategoryFilterProvider.notifier).state = category;
  }
}