import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/repositories/goods_repository.dart';
import 'package:stockmanager/data/repositories/product_repository.dart';
import '../../data/models/product_model.dart';
import 'add_product_state.dart';

// Provider 생성
final addProductViewModelProvider =
    StateNotifierProvider.autoDispose<AddProductViewModel, AddProductState>(
  (ref) => AddProductViewModel(
    ref.watch(goodsRepositoryProvider),
    ref.watch(productRepositoryProvider),
  ),
);

class AddProductViewModel extends StateNotifier<AddProductState> {
  final GoodsRepository _goodsRepository;
  final ProductRepository _productRepository;

  AddProductViewModel(this._goodsRepository, this._productRepository)
      : super(const AddProductState());

  // 연관 상품 정보 가져오기
  Future<void> fetchRelatedGoods(String goodsId) async {
    state = state.copyWith(isLoadingGoods: true, goodsError: null);
    try {
      // GoodsRepository를 통해 특정 상품의 Stream을 가져옴
      final goodsStream = _goodsRepository.getGoodsStream(); // Firestore에서 Goods 데이터를 가져오는 방식에 따라 수정이 필요할 수 있습니다.
      // 예시: goodsRepository에 getGoodsById(goodsId) 메서드가 있다면 더 효율적입니다.
      // final goods = await _goodsRepository.getGoodsById(goodsId);
      
      // 임시로 전체 리스트에서 찾기
      final allGoods = await goodsStream.first;
      final goods = allGoods.firstWhere((g) => g.itemNumber == goodsId, orElse: () => throw Exception('상품을 찾을 수 없습니다.'));
      
      final costPerPiece = (double.parse(goods.price!) / double.parse(goods.number!)).toStringAsFixed(1);
      final weightPerPiece = (double.parse(goods.weight!) / double.parse(goods.number!)).toStringAsFixed(1);

      state = state.copyWith(
        isLoadingGoods: false,
        relatedGoods: goods,
        costPerPiece: costPerPiece,
        weightPerPiece: weightPerPiece,
      );
    } catch (e) {
      state = state.copyWith(isLoadingGoods: false, goodsError: e.toString());
    }
  }

  // 판매가 등 계산 로직
  void calculate({
    required String numberOfPieces,
    required String commissionRate,
    required String earningRate,
    String deliveryCharge = '0',
    bool isFreeShipping = false,
  }) {
    if (state.relatedGoods == null) return;

    final pCost = (double.parse(state.costPerPiece) * int.parse(numberOfPieces));
    final pWeight = (double.parse(state.weightPerPiece) * int.parse(numberOfPieces));
    
    double sPrice;
    final costForCalc = isFreeShipping ? pCost + double.parse(deliveryCharge) : pCost;
    sPrice = (costForCalc / (1 - (double.parse(earningRate)/100) - (double.parse(commissionRate)/100)));
    sPrice = (sPrice / 10).round() * 10.0; // 1의 자리에서 반올림

    final commission = (sPrice * (double.parse(commissionRate) / 100)).round();
    final earning = (sPrice * (double.parse(earningRate) / 100)).round();
    
    state = state.copyWith(
      productCost: pCost.toString(),
      productWeight: pWeight.toString(),
      sellingPrice: sPrice.toString(),
      commission: commission.toString(),
      earning: earning.toString(),
    );
  }

  // 최종 제품 저장 로직
  Future<bool> saveProduct({
    /* form에서 입력받은 모든 데이터 */
    required String productNumber,
    required String productName,
    required String numberOfPieces,
    required String commissionRate,
    required String earningRate,
    required String deliveryMethod,
    required String stock,
    required String memo,
  }) async {
    if (state.relatedGoods == null) return false;
    state = state.copyWith(isSaving: true, saveError: null);
    try {
      final newProduct = ProductFirebaseModel(
        itemNumber: productNumber,
        title: productName,
        g_itemNumber: state.relatedGoods!.itemNumber,
        g_title: state.relatedGoods!.title,
        category: state.relatedGoods!.category,
        number: numberOfPieces,
        p_price: state.costPerPiece,
        weight: state.productWeight,
        costPrice: state.productCost,
        price: state.sellingPrice,
        commission: state.commission,
        earning: state.earning,
        commissionRate: commissionRate,
        earningRate: earningRate,
        deliveryMethod: deliveryMethod,
        stock: stock,
        memo: memo,
        inputDay: DateTime.now().toString(),
      );
      await _productRepository.saveProduct(newProduct);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: e.toString());
      return false;
    }
  }
}