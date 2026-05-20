import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/material_repository.dart';
import '../../data/repositories/product_repository.dart';
import 'add_product_state.dart';

final addProductViewModelProvider =
    StateNotifierProvider.autoDispose<AddProductViewModel, AddProductState>(
  (ref) => AddProductViewModel(ref),
);

class AddProductViewModel extends StateNotifier<AddProductState> {
  final Ref _ref;

  AddProductViewModel(this._ref) : super(const AddProductState());

  MaterialRepository get _materialRepository =>
      _ref.read(materialRepositoryProvider);
  ProductRepository get _productRepository =>
      _ref.read(productRepositoryProvider);

  /// Look up a material by its `original_item_number` (UI: 연관상품코드).
  Future<void> fetchRelatedGoods(String goodsCode) async {
    state = state.copyWith(isLoadingGoods: true, clearGoodsError: true);
    try {
      final allMaterials = await _materialRepository.getMaterialsStream().first;
      final material = allMaterials.firstWhere(
        (m) => m.originalItemNumber == goodsCode,
        orElse: () => throw Exception('상품을 찾을 수 없습니다.'),
      );

      final priceNum = material.price ?? 0;
      final quantityNum = material.quantity ?? 0;
      final weightNum = double.tryParse(material.weight ?? '') ?? 0;

      if (quantityNum == 0) {
        throw Exception('상품 갯수가 0이라 개당 원가를 계산할 수 없습니다.');
      }

      final costPerPiece = (priceNum / quantityNum).toStringAsFixed(1);
      final weightPerPiece = (weightNum / quantityNum).toStringAsFixed(1);

      state = state.copyWith(
        isLoadingGoods: false,
        relatedGoods: material,
        costPerPiece: costPerPiece,
        weightPerPiece: weightPerPiece,
      );
    } catch (e) {
      state = state.copyWith(isLoadingGoods: false, goodsError: e.toString());
    }
  }

  void calculate({
    required String numberOfPieces,
    required String commissionRate,
    required String earningRate,
    String deliveryCharge = '0',
    bool isFreeShipping = false,
  }) {
    if (state.relatedGoods == null) return;

    final pieces = int.tryParse(numberOfPieces) ?? 0;
    final pCost = (double.tryParse(state.costPerPiece) ?? 0) * pieces;
    final pWeight = (double.tryParse(state.weightPerPiece) ?? 0) * pieces;

    final eRate = double.tryParse(earningRate) ?? 0;
    final cRate = double.tryParse(commissionRate) ?? 0;
    final dCharge = double.tryParse(deliveryCharge) ?? 0;

    final denominator = 1 - (eRate / 100) - (cRate / 100);
    if (denominator <= 0) return;

    final costForCalc = isFreeShipping ? pCost + dCharge : pCost;
    double sPrice = costForCalc / denominator;
    sPrice = (sPrice / 10).round() * 10.0;

    final commission = (sPrice * (cRate / 100)).round();
    final earning = (sPrice * (eRate / 100)).round();

    state = state.copyWith(
      productCost: pCost.toString(),
      productWeight: pWeight.toString(),
      sellingPrice: sPrice.toString(),
      commission: commission.toString(),
      earning: earning.toString(),
    );
  }

  Future<bool> saveProduct({
    required String productNumber,
    required String productName,
    required int? categoryId,
    required String numberOfPieces,
    required String commissionRate,
    required String earningRate,
    required String deliveryMethod,
    required String stock,
    required String memo,
  }) async {
    final related = state.relatedGoods;
    if (related == null) return false;
    state = state.copyWith(isSaving: true, clearSaveError: true);
    try {
      String? firebaseCategoryFallback;
      if (categoryId != null) {
        final tree = await _ref.read(categoryTreeProvider.future);
        firebaseCategoryFallback = tree.byId[categoryId]?.name;
      }
      final newProduct = ProductModel(
        name: productName,
        productCode: productNumber,
        relatedProductCode: related.originalItemNumber,
        categoryId: categoryId ?? related.categoryId,
        firebaseCategory:
            firebaseCategoryFallback ?? related.firebaseCategory,
        quantity: int.tryParse(numberOfPieces),
        unitPrice: int.tryParse(state.costPerPiece.split('.').first),
        weight: state.productWeight,
        costPrice: int.tryParse(state.productCost.split('.').first),
        totalPrice: int.tryParse(state.sellingPrice.split('.').first),
        commission: num.tryParse(state.commission),
        earning: num.tryParse(state.earning),
        commissionRate: num.tryParse(commissionRate),
        earningRate: num.tryParse(earningRate),
        deliveryMethod: deliveryMethod,
        stockQuantity: int.tryParse(stock),
        memo: memo,
      );
      await _productRepository.save(newProduct);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: e.toString());
      return false;
    }
  }
}
