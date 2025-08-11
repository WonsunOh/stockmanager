import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/add_product_state.dart';
import 'package:stockmanager/presentation/viewmodels/add_product_viewmodel.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Field Controllers
  final _relatedGoodsIdController = TextEditingController();
  final _productNumberController = TextEditingController();
  final _productNameController = TextEditingController();
  final _numberOfPiecesController = TextEditingController();
  final _commissionRateController = TextEditingController();
  final _earningRateController = TextEditingController();
  final _deliveryChargeController = TextEditingController(text: '0');
  final _stockController = TextEditingController();
  final _memoController = TextEditingController();
  
  // Dropdown State
  String _deliveryMethod = '유료배송';

  @override
  void dispose() {
    // 모든 컨트롤러 리소스 해제
    _relatedGoodsIdController.dispose();
    _productNameController.dispose();
    _productNumberController.dispose();
    _numberOfPiecesController.dispose();
    _commissionRateController.dispose();
    _earningRateController.dispose();
    _deliveryChargeController.dispose();
    _stockController.dispose();
    _memoController.dispose();
    super.dispose();
  }
  
  // '판매가 계산' 버튼 로직
  void _onCalculate() {
    // 키보드 숨기기
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      ref.read(addProductViewModelProvider.notifier).calculate(
            numberOfPieces: _numberOfPiecesController.text,
            commissionRate: _commissionRateController.text,
            earningRate: _earningRateController.text,
            isFreeShipping: _deliveryMethod == '무료배송',
            deliveryCharge: _deliveryChargeController.text,
          );
    }
  }

  // '제품 추가하기' 버튼 로직
  void _onSave() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(addProductViewModelProvider.notifier).saveProduct(
            productNumber: _productNumberController.text,
            productName: _productNameController.text,
            numberOfPieces: _numberOfPiecesController.text,
            commissionRate: _commissionRateController.text,
            earningRate: _earningRateController.text,
            deliveryMethod: _deliveryMethod,
            stock: _stockController.text,
            memo: _memoController.text,
        );
      if (success && mounted) {
        // 저장 성공 시 이전 화면으로 이동
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel의 State를 watch하여 UI를 자동 갱신
    final state = ref.watch(addProductViewModelProvider);
    final viewModel = ref.read(addProductViewModelProvider.notifier);
    final numberFormatter = NumberFormat('###,###,###');

    // ViewModel의 저장 상태(isSaving, saveError)를 감지
    ref.listen<AddProductState>(addProductViewModelProvider, (previous, next) {
        if (next.saveError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('저장 실패: ${next.saveError}')),
            );
        }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('제품 추가')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 연관 상품 찾기
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _relatedGoodsIdController,
                      decoration: const InputDecoration(labelText: '연관상품코드', border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? '코드를 입력하세요.' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: state.isLoadingGoods
                          ? null
                          : () => viewModel.fetchRelatedGoods(_relatedGoodsIdController.text),
                      child: state.isLoadingGoods
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('찾기'),
                    ),
                  ),
                ],
              ),
              if (state.goodsError != null) 
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('오류: ${state.goodsError}', style: const TextStyle(color: Colors.red)),
                ),
              
              // 2. 연관 상품 정보 표시
              if (state.relatedGoods != null)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('구성 상품: ${state.relatedGoods!.title}', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('개당 원가: ${state.costPerPiece}원'),
                        Text('개당 무게: ${state.weightPerPiece}g'),
                      ],
                    ),
                  ),
                ),
              
              // 3. 제품 정보 입력
              _buildTextFormField(_productNumberController, '제품코드'),
              _buildTextFormField(_productNameController, '제품명'),
              _buildTextFormField(_numberOfPiecesController, '원료의 갯수', isNumber: true),
              _buildTextFormField(_commissionRateController, '수수료율 (%)', isNumber: true),
              _buildTextFormField(_earningRateController, '수익률 (%)', isNumber: true),
              
              DropdownButtonFormField<String>(
                  value: _deliveryMethod,
                  decoration: const InputDecoration(labelText: '배송방법', border: OutlineInputBorder()),
                  items: ['유료배송', '무료배송'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _deliveryMethod = val!)),
              
              if (_deliveryMethod == '무료배송')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildTextFormField(_deliveryChargeController, '배송비 (원)', isNumber: true),
                ),
              
              // 4. 계산 및 결과 표시
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _onCalculate, child: const Text('판매가 계산')),
              if (state.sellingPrice.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text('제품원가: ${numberFormatter.format(double.parse(state.productCost))}원'),
                          Text('판매가: ${numberFormatter.format(double.parse(state.sellingPrice))}원'),
                          Text('수수료: ${numberFormatter.format(double.parse(state.commission))}원'),
                          Text('수익: ${numberFormatter.format(double.parse(state.earning))}원'),
                        ],
                      ),
                    ),
                  ),
                ),

              // 5. 최종 저장
              const SizedBox(height: 24),
              _buildTextFormField(_stockController, '제품 재고', isNumber: true),
              _buildTextFormField(_memoController, '메모', maxLines: 2),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isSaving ? null : _onSave,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: state.isSaving 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : const Text('제품 추가하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TextFormField를 만드는 헬퍼 메서드
  Widget _buildTextFormField(TextEditingController controller, String label, {bool isNumber = false, int? maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        maxLines: maxLines,
        validator: (value) => value == null || value.isEmpty ? '$label 입력이 필요합니다.' : null,
      ),
    );
  }
}