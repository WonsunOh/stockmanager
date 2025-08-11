import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:stockmanager/data/repositories/goods_repository.dart';

import '../../data/models/goods_firebase_model.dart';

// Provider 생성
final addGoodsViewModelProvider =
    StateNotifierProvider.autoDispose<AddGoodsViewModel, AsyncValue<void>>(
  (ref) => AddGoodsViewModel(ref.watch(goodsRepositoryProvider)),
);

class AddGoodsViewModel extends StateNotifier<AsyncValue<void>> {
  final GoodsRepository _repository;

  AddGoodsViewModel(this._repository) : super(const AsyncValue.data(null));

  // 상품을 저장(추가 또는 업데이트)하는 메서드
  Future<bool> saveGoods({
    GoodsFirebaseModel? existingGoods,
    required String itemNumber,
    required String title,
    required String category,
    required String price,
    required String number,
    required String weight,
    required String stock,
    required String memo,
  }) async {
    state = const AsyncValue.loading();
    try {
      // 입력받은 값으로 GoodsFirebaseModel 객체 생성
      final goods = GoodsFirebaseModel(
        itemNumber: itemNumber,
        category: category,
        title: title,
        inputDay: existingGoods?.inputDay ?? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
        price: price,
        number: number,
        weight: weight,
        stock: stock,
        memo: memo,
      );

      await _repository.saveGoods(goods);
      
      state = const AsyncValue.data(null);
      return true; // 성공
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false; // 실패
    }
  }
}