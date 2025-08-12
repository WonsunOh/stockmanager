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
     required String imageUrlsString, // 1. 이미지 URL 문자열을 받는 파라미터 추가
  }) async {
    state = const AsyncValue.loading();
    try {
      // 2. 콤마(,)로 구분된 문자열을 공백 제거 후 리스트로 변환
      final imageUrls = imageUrlsString
          .split(',')
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty) // 빈 문자열은 제외
          .toList();
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
        imageUrls: imageUrls, // 3. 변환된 리스트를 모델에 할당
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