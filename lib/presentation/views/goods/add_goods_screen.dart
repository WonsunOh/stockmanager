import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/presentation/viewmodels/add_goods_viewmodel.dart';

import '../../../data/models/goods_firebase_model.dart';

class AddGoodsScreen extends ConsumerStatefulWidget {
  final GoodsFirebaseModel? goods; // 수정을 위한 기존 상품 데이터

  const AddGoodsScreen({super.key, this.goods});

  @override
  ConsumerState<AddGoodsScreen> createState() => _AddGoodsScreenState();
}

class _AddGoodsScreenState extends ConsumerState<AddGoodsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Field Controllers
  late final TextEditingController _itemNumberController;
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _numberController;
  late final TextEditingController _weightController;
  late final TextEditingController _stockController;
  late final TextEditingController _memoController;

  // Dropdown State
  String? _selectedCategory;
  final List<String> _categories = ['과자', '사탕', '젤리', '초콜릿', '껌', '차,음료', '기타'];

  @override
  void initState() {
    super.initState();
    final goods = widget.goods;
    _itemNumberController =
        TextEditingController(text: goods?.itemNumber ?? '');
    _titleController = TextEditingController(text: goods?.title ?? '');
    _priceController = TextEditingController(text: goods?.price ?? '');
    _numberController = TextEditingController(text: goods?.number ?? '');
    _weightController = TextEditingController(text: goods?.weight ?? '');
    _stockController = TextEditingController(text: goods?.stock ?? '');
    _memoController = TextEditingController(text: goods?.memo ?? '');
    _selectedCategory = goods?.category;
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
      final success =
          await ref.read(addGoodsViewModelProvider.notifier).saveGoods(
                existingGoods: widget.goods,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goods == null ? '상품 추가' : '상품 수정'),
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
                readOnly: widget.goods != null, // 수정 시에는 상품코드 변경 불가
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
