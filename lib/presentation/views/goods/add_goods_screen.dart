import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/material_model.dart';
import '../../viewmodels/add_goods_viewmodel.dart';

class AddGoodsScreen extends ConsumerStatefulWidget {
  final MaterialModel? material;

  const AddGoodsScreen({super.key, this.material});

  @override
  ConsumerState<AddGoodsScreen> createState() => _AddGoodsScreenState();
}

class _AddGoodsScreenState extends ConsumerState<AddGoodsScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _itemNumberController;
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _numberController;
  late final TextEditingController _weightController;
  late final TextEditingController _stockController;
  late final TextEditingController _memoController;

  String? _selectedCategory;
  final List<String> _categories = ['과자', '사탕', '젤리', '초콜릿', '껌', '차,음료', '기타'];

  @override
  void initState() {
    super.initState();
    final m = widget.material;
    _itemNumberController = TextEditingController(text: m?.originalItemNumber ?? '');
    _titleController = TextEditingController(text: m?.name ?? '');
    _priceController = TextEditingController(text: m?.price?.toString() ?? '');
    _numberController = TextEditingController(text: m?.quantity?.toString() ?? '');
    _weightController = TextEditingController(text: m?.weight ?? '');
    _stockController = TextEditingController(text: m?.stockQuantity?.toString() ?? '');
    _memoController = TextEditingController(text: m?.memo ?? '');
    _selectedCategory = m?.firebaseCategory;
  }

  @override
  void dispose() {
    _itemNumberController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _numberController.dispose();
    _weightController.dispose();
    _stockController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(addGoodsViewModelProvider.notifier).saveGoods(
            existingGoods: widget.material,
            itemNumber: _itemNumberController.text,
            title: _titleController.text,
            category: _selectedCategory!,
            price: _priceController.text,
            number: _numberController.text,
            weight: _weightController.text,
            stock: _stockController.text,
            memo: _memoController.text,
          );
      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addGoodsViewModelProvider).isLoading;
    final isEdit = widget.material != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '상품 수정' : '상품 추가'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                    labelText: '카테고리', border: OutlineInputBorder()),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? '카테고리를 선택하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemNumberController,
                decoration: const InputDecoration(
                    labelText: '상품코드', border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.isEmpty ? '상품코드를 입력하세요.' : null,
                readOnly: isEdit,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: '상품명', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? '상품명을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                    labelText: '상품가격 (원)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? '가격을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(
                    labelText: '상품갯수', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? '갯수를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                    labelText: '상품무게 (g)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? '무게를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                    labelText: '상품재고', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? '재고를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(
                    labelText: '메모', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
