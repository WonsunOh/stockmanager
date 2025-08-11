// freezed import 문을 모두 삭제하고, 실제 모델 파일 경로만 남깁니다.

import '../../data/models/goods_firebase_model.dart';

// 일반 클래스로 상태를 정의합니다.
class AddProductState {
  final bool isLoadingGoods;
  final String? goodsError;
  final GoodsFirebaseModel? relatedGoods;
  final String costPerPiece;
  final String weightPerPiece;
  final String productCost;
  final String productWeight;
  final String sellingPrice;
  final String commission;
  final String earning;
  final bool isSaving;
  final String? saveError;

  // 생성자
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

  // freezed가 자동으로 만들어주던 copyWith 메서드를 직접 작성합니다.
  AddProductState copyWith({
    bool? isLoadingGoods,
    String? goodsError,
    GoodsFirebaseModel? relatedGoods,
    String? costPerPiece,
    String? weightPerPiece,
    String? productCost,
    String? productWeight,
    String? sellingPrice,
    String? commission,
    String? earning,
    bool? isSaving,
    String? saveError,
    bool clearGoodsError = false, // 에러 메시지를 초기화하는 옵션 추가
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