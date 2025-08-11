import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/presentation/viewmodels/product_list_viewmodel.dart';

// TODO: AddProductScreen 경로 추가 필요
// import 'add_product_screen.dart'; 

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListState = ref.watch(productListViewModelProvider);
    final numberFormatter = NumberFormat('###,###,###');

    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 목록'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context,'/'),
          icon: const Icon(Icons.home),
        ),
        actions: [
          IconButton(
            tooltip: '제품 추가',
            onPressed: () {
              // Get.to(() => const AddProductScreen()); // TODO: 제품 추가 화면으로 이동
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: productListState.when(
        data: (products) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('제품명')),
              DataColumn(label: Text('제품코드')),
              DataColumn(label: Text('제품원가'), numeric: true),
              DataColumn(label: Text('판매가'), numeric: true),
              DataColumn(label: Text('수익'), numeric: true),
              DataColumn(label: Text('재고'), numeric: true),
            ],
            rows: products.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item.title ?? '')),
                  DataCell(Text(item.itemNumber ?? '')),
                  DataCell(Text('${numberFormatter.format(double.tryParse(item.costPrice ?? '0'))}원')),
                  DataCell(Text('${numberFormatter.format(double.tryParse(item.price ?? '0'))}원')),
                  DataCell(Text('${numberFormatter.format(double.tryParse(item.earning ?? '0'))}원')),
                  DataCell(Text(item.stock ?? '0')),
                ],
                onSelectChanged: (isSelected) {
                  if (isSelected ?? false) {
                    // TODO: 제품 상세 화면으로 이동하는 로직
                  }
                },
              );
            }).toList(),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('에러 발생: $err')),
      ),
    );
  }
}