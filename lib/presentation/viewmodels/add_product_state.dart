import '../../data/models/material_model.dart';

class AddProductState {
  final bool isLoadingGoods;
  final String? goodsError;
  final MaterialModel? relatedGoods;
  final String costPerPiece;
  final String weightPerPiece;
  final String productCost;
  final String productWeight;
  final String sellingPrice;
  final String commission;
  final String earning;
  final bool isSaving;
  final String? saveError;

  const AddProductState({
    this.isLoadingGoods = false,
    this.goodsError,
    this.relatedGoods,
    this.costPerPiece = '',
    this.weightPerPiece = '',
    this.productCost = '',
    this.productWeight = '',
    this.sellingPrice = '',
    this.commission = '',
    this.earning = '',
    this.isSaving = false,
    this.saveError,
  });

  AddProductState copyWith({
    bool? isLoadingGoods,
    String? goodsError,
    MaterialModel? relatedGoods,
    String? costPerPiece,
    String? weightPerPiece,
    String? productCost,
    String? productWeight,
    String? sellingPrice,
    String? commission,
    String? earning,
    bool? isSaving,
    String? saveError,
    bool clearGoodsError = false,
    bool clearSaveError = false,
  }) {
    return AddProductState(
      isLoadingGoods: isLoadingGoods ?? this.isLoadingGoods,
      goodsError: clearGoodsError ? null : goodsError ?? this.goodsError,
      relatedGoods: relatedGoods ?? this.relatedGoods,
      costPerPiece: costPerPiece ?? this.costPerPiece,
      weightPerPiece: weightPerPiece ?? this.weightPerPiece,
      productCost: productCost ?? this.productCost,
      productWeight: productWeight ?? this.productWeight,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      commission: commission ?? this.commission,
      earning: earning ?? this.earning,
      isSaving: isSaving ?? this.isSaving,
      saveError: clearSaveError ? null : saveError ?? this.saveError,
    );
  }
}
