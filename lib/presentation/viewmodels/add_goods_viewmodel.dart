import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/material_model.dart';
import '../../data/repositories/material_repository.dart';

final addGoodsViewModelProvider =
    StateNotifierProvider.autoDispose<AddGoodsViewModel, AsyncValue<void>>(
  (ref) => AddGoodsViewModel(ref.watch(materialRepositoryProvider)),
);

class AddGoodsViewModel extends StateNotifier<AsyncValue<void>> {
  final MaterialRepository _repository;

  AddGoodsViewModel(this._repository) : super(const AsyncValue.data(null));

  Future<bool> saveGoods({
    MaterialModel? existingGoods,
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
      final material = MaterialModel(
        id: existingGoods?.id,
        name: title,
        firebaseCategory: category,
        categoryId: existingGoods?.categoryId,
        originalItemNumber: itemNumber,
        price: int.tryParse(price),
        quantity: int.tryParse(number),
        weight: weight,
        stockQuantity: int.tryParse(stock),
        memo: memo,
        unit: existingGoods?.unit ?? '개',
        unitPrice: existingGoods?.unitPrice,
        imageUrl: existingGoods?.imageUrl,
      );

      await _repository.save(material);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
