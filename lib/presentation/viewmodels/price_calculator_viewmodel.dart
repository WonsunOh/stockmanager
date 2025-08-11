import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 계산기의 상태를 담을 클래스
class PriceCalculatorState {
  final String sellingPrice;
  final String commission;
  final String earning;

  const PriceCalculatorState({
    this.sellingPrice = '0',
    this.commission = '0',
    this.earning = '0',
  });

  PriceCalculatorState copyWith({String? sellingPrice, String? commission, String? earning}) {
    return PriceCalculatorState(
      sellingPrice: sellingPrice ?? this.sellingPrice,
      commission: commission ?? this.commission,
      earning: earning ?? this.earning,
    );
  }
}

// 2. ViewModel을 제공할 Provider
final priceCalculatorViewModelProvider =
    StateNotifierProvider.autoDispose<PriceCalculatorViewModel, PriceCalculatorState>(
  (ref) => PriceCalculatorViewModel(),
);

// 3. ViewModel: 계산 로직 담당
class PriceCalculatorViewModel extends StateNotifier<PriceCalculatorState> {
  PriceCalculatorViewModel() : super(const PriceCalculatorState());

  void calculate({
    required String costPrice,
    required String commissionRate,
    required String earningRate,
    required String deliveryMethod,
    String deliveryCharge = '0',
  }) {
    // String을 double로 안전하게 변환 (실패 시 0.0 반환)
    final pCost = double.tryParse(costPrice) ?? 0.0;
    final cRate = double.tryParse(commissionRate) ?? 0.0;
    final eRate = double.tryParse(earningRate) ?? 0.0;
    final dCharge = double.tryParse(deliveryCharge) ?? 0.0;

    if (pCost <= 0) return;

    double sellingPrice;
    final costForCalc = deliveryMethod == '무료배송' ? pCost + dCharge : pCost;
    
    // 분모가 0이 되는 것을 방지
    final denominator = 1 - (eRate / 100) - (cRate / 100);
    if (denominator <= 0) {
        // 에러 처리 또는 기본값 설정 (여기서는 계산 중단)
        return;
    }

    sellingPrice = costForCalc / denominator;
    sellingPrice = (sellingPrice / 10).round() * 10.0; // 1의 자리에서 반올림

    final commission = sellingPrice * (cRate / 100);
    final earning = sellingPrice * (eRate / 100);
    
    // 계산된 결과로 상태 업데이트
    state = state.copyWith(
      sellingPrice: sellingPrice.round().toString(),
      commission: commission.round().toString(),
      earning: earning.round().toString(),
    );
  }
}