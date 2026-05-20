import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/material_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/material_repository.dart';

final addGoodsViewModelProvider =
    StateNotifierProvider.autoDispose<AddGoodsViewModel, AsyncValue<void>>(
  (ref) => AddGoodsViewModel(ref),
);

class AddGoodsViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AddGoodsViewModel(this._ref) : super(const AsyncValue.data(null));

  MaterialRepository get _repository =>
      _ref.read(materialRepositoryProvider);

  Future<bool> saveGoods({
    MaterialModel? existingGoods,
    required String itemNumber,
    required String title,
    required int? categoryId,
    required String price,
    required String number,
    required String weight,
    required String stock,
    required String memo,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Try to keep firebase_category in sync with the (newly) selected
      // category leaf so legacy reads keep showing something sensible.
      String? firebaseCategoryFallback;
      if (categoryId != null) {
        final tree = await _ref.read(categoryTreeProvider.future);
        firebaseCategoryFallback = tree.byId[categoryId]?.name;
      }

      final material = MaterialModel(
        id: existingGoods?.id,
        name: title,
        firebaseCategory:
            firebaseCategoryFallback ?? existingGoods?.firebaseCategory,
        categoryId: categoryId,
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
