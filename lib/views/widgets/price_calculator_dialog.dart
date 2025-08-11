import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/presentation/viewmodels/price_calculator_viewmodel.dart';

class PriceCalculatorDialog extends ConsumerStatefulWidget {
  const PriceCalculatorDialog({super.key});

  @override
  ConsumerState<PriceCalculatorDialog> createState() => _PriceCalculatorDialogState();
}

class _PriceCalculatorDialogState extends ConsumerState<PriceCalculatorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _commissionController = TextEditingController();
  final _earningController = TextEditingController();
  final _deliveryChargeController = TextEditingController(text: '0');
  
  String _deliveryMethod = '유료배송';
  final numberFormatter = NumberFormat('###,###,###');

  @override
  void dispose() {
    _costController.dispose();
    _commissionController.dispose();
    _earningController.dispose();
    _deliveryChargeController.dispose();
    super.dispose();
  }

  void _onCalculate() {
    if (_formKey.currentState!.validate()) {
      ref.read(priceCalculatorViewModelProvider.notifier).calculate(
            costPrice: _costController.text,
            commissionRate: _commissionController.text,
            earningRate: _earningController.text,
            deliveryMethod: _deliveryMethod,
            deliveryCharge: _deliveryChargeController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel의 상태를 watch하여 계산 결과가 변경될 때마다 UI 갱신
    final calculatorState = ref.watch(priceCalculatorViewModelProvider);

    return AlertDialog(
      title: const Text('상품 판매가 계산기'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextFormField(_costController, '원가'),
              _buildTextFormField(_commissionController, '수수료율 (%)'),
              _buildTextFormField(_earningController, '수익률 (%)'),
              
              DropdownButtonFormField<String>(
                value: _deliveryMethod,
                items: ['유료배송', '무료배송'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _deliveryMethod = val!),
              ),

              if (_deliveryMethod == '무료배송')
                _buildTextFormField(_deliveryChargeController, '배송비 (원)'),
              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onCalculate,
                child: const Text('계산하기'),
              ),
              const SizedBox(height: 16),
              
              // 계산 결과 표시
              _buildResultRow('상품판매가', numberFormatter.format(int.parse(calculatorState.sellingPrice))),
              _buildResultRow('수수료', numberFormatter.format(int.parse(calculatorState.commission))),
              _buildResultRow('수익', numberFormatter.format(int.parse(calculatorState.earning))),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (v) => v!.isEmpty ? '$label 입력이 필요합니다.' : null,
      ),
    );
  }

  Widget _buildResultRow(String title, String result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$result 원'),
        ],
      ),
    );
  }
}