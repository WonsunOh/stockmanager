import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/category_repository.dart';
import '../../viewmodels/add_product_state.dart';
import '../../viewmodels/add_product_viewmodel.dart';
import '../../widgets/category_cascade_dropdown.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _relatedGoodsIdController = TextEditingController();
  final _productNumberController = TextEditingController();
  final _productNameController = TextEditingController();
  final _numberOfPiecesController = TextEditingController();
  final _commissionRateController = TextEditingController();
  final _earningRateController = TextEditingController();
  final _deliveryChargeController = TextEditingController(text: '0');
  final _stockController = TextEditingController();
  final _memoController = TextEditingController();

  String _deliveryMethod = '유료배송';
  int? _selectedCategoryId;
  int? _seedCategoryIdFromMaterial;

  @override
  void dispose() {
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

  void _onCalculate() {
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

  void _onSave() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 끝까지 선택해주세요.')),
      );
      return;
    }
    final success = await ref.read(addProductViewModelProvider.notifier).saveProduct(
          productNumber: _productNumberController.text,
          productName: _productNameController.text,
          categoryId: _selectedCategoryId,
          numberOfPieces: _numberOfPiecesController.text,
          commissionRate: _commissionRateController.text,
          earningRate: _earningRateController.text,
          deliveryMethod: _deliveryMethod,
          stock: _stockController.text,
          memo: _memoController.text,
        );
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductViewModelProvider);
    final viewModel = ref.read(addProductViewModelProvider.notifier);
    final numberFormatter = NumberFormat('###,###,###');
    final treeAsync = ref.watch(categoryTreeProvider);

    ref.listen<AddProductState>(addProductViewModelProvider, (previous, next) {
      if (next.saveError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${next.saveError}')),
        );
      }
      // When related material loads, seed the category cascade with its
      // categoryId so the dropdowns rebuild with that selection visible.
      final newSeed = next.relatedGoods?.categoryId;
      if (newSeed != null && newSeed != _seedCategoryIdFromMaterial) {
        setState(() {
          _seedCategoryIdFromMaterial = newSeed;
          _selectedCategoryId = newSeed;
        });
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _relatedGoodsIdController,
                      decoration: const InputDecoration(
                          labelText: '연관상품코드', border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? '코드를 입력하세요.' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: state.isLoadingGoods
                          ? null
                          : () => viewModel
                              .fetchRelatedGoods(_relatedGoodsIdController.text),
                      child: state.isLoadingGoods
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('찾기'),
                    ),
                  ),
                ],
              ),
              if (state.goodsError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('오류: ${state.goodsError}',
                      style: const TextStyle(color: Colors.red)),
                ),
              if (state.relatedGoods != null)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('구성 상품: ${state.relatedGoods!.name}',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          '카테고리: ${treeAsync.maybeWhen(
                            data: (tree) => tree
                                .pathString(state.relatedGoods!.categoryId),
                            orElse: () =>
                                state.relatedGoods!.firebaseCategory ?? '-',
                          )}',
                        ),
                        const SizedBox(height: 8),
                        Text('개당 원가: ${state.costPerPiece}원'),
                        Text('개당 무게: ${state.weightPerPiece}g'),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              CategoryCascadeDropdown(
                key: ValueKey(_seedCategoryIdFromMaterial),
                initialCategoryId: _seedCategoryIdFromMaterial,
                onChanged: (id) => _selectedCategoryId = id,
              ),
              _buildTextFormField(_productNumberController, '제품코드'),
              _buildTextFormField(_productNameController, '제품명'),
              _buildTextFormField(_numberOfPiecesController, '원료의 갯수',
                  isNumber: true),
              _buildTextFormField(_commissionRateController, '수수료율 (%)',
                  isNumber: true),
              _buildTextFormField(_earningRateController, '수익률 (%)',
                  isNumber: true),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                  value: _deliveryMethod,
                  decoration: const InputDecoration(
                      labelText: '배송방법', border: OutlineInputBorder()),
                  items: ['유료배송', '무료배송']
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _deliveryMethod = val!)),
              if (_deliveryMethod == '무료배송')
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildTextFormField(
                      _deliveryChargeController, '배송비 (원)',
                      isNumber: true),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: _onCalculate, child: const Text('판매가 계산')),
              if (state.sellingPrice.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                              '제품원가: ${numberFormatter.format(double.parse(state.productCost))}원'),
                          Text(
                              '판매가: ${numberFormatter.format(double.parse(state.sellingPrice))}원'),
                          Text(
                              '수수료: ${numberFormatter.format(double.parse(state.commission))}원'),
                          Text(
                              '수익: ${numberFormatter.format(double.parse(state.earning))}원'),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _buildTextFormField(_stockController, '제품 재고', isNumber: true),
              _buildTextFormField(_memoController, '메모', maxLines: 2),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.isSaving ? null : _onSave,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: state.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('제품 추가하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      {bool isNumber = false, int? maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? '$label 입력이 필요합니다.' : null,
      ),
    );
  }
}
