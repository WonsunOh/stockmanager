import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../views/screen/add_product_form.dart';
import '../../../views/widgets/price_calculator_dialog.dart';
import '../../viewmodels/goods_list_viewmodel.dart';

// ... (AddGoodsScreen, DetailViewScreen 등의 import 경로 수정 필요)

class GoodsListScreen extends ConsumerWidget {
  const GoodsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodsListState = ref.watch(goodsListViewModelProvider);
    final selectedCategory = ref.watch(goodsCategoryFilterProvider);
    final numberFormatter = NumberFormat('###,###,###');

    final List<String> goodsTypeToString = [
      '모든카테고리', '과자', '사탕', '젤리', '초콜릿', '껌', '차,음료', '기타',
    ];

    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: selectedCategory,
          items: goodsTypeToString.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            // Dropdown 메뉴 변경 시 ViewModel의 setCategory 메서드 호출
            if (newValue != null) {
              ref.read(goodsListViewModelProvider.notifier).setCategory(newValue);
            }
          },
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context,'/'),
          icon: const Icon(Icons.home),
        ),
        actions: [
          IconButton(
            tooltip: '제품 생성',
            onPressed: () { showAddProductForm(context, ref); },
            icon: const Icon(Icons.calculate),
          ),
          IconButton(
            tooltip: '상품 추가',
            onPressed: () { /* TODO: Get.to(() => AddGoodsScreen()) 연결 */ },
            icon: const Icon(Icons.create),
          ),
          IconButton(
  tooltip: '판매가 계산기',
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => const PriceCalculatorDialog(),
    );
  },
  icon: const Icon(Icons.calculate),
),
        ],
      ),
      body: goodsListState.when(
        data: (goods) {
          return DataTable2(
            // 이 속성이 핵심입니다. 상단 1개의 행(헤더)을 고정합니다.
            fixedTopRows: 1,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 900, // 전체 테이블의 최소 너비를 지정하여 컬럼이 잘리지 않도록 함
            columns: const [
              DataColumn2(label: Text('카테고리'), size: ColumnSize.L),
        DataColumn2(label: Text('아이템넘버'), size: ColumnSize.M), // <-- 위치 변경
        DataColumn2(label: Text('상품명'), size: ColumnSize.L),
        DataColumn2(label: Text('상품가격'), numeric: true, size: ColumnSize.M),
        DataColumn2(label: Text('개당가격'), numeric: true, size: ColumnSize.M),
        DataColumn2(label: Text('상품갯수'), numeric: true, size: ColumnSize.S), // <-- 추가
        DataColumn2(label: Text('상품무게(g)'), numeric: true, size: ColumnSize.M), // <-- 추가
        DataColumn2(label: Text('재고'), numeric: true, size: ColumnSize.S),
        DataColumn2(label: Text('메모'), size: ColumnSize.L), // <-- 추가
            ],
            rows: goods.map((item) {
              final pricePerPiece = (double.tryParse(item.price ?? '0')! /
                      double.tryParse(item.number ?? '1')!)
                  .toStringAsFixed(1);
                      
              return DataRow(
                cells: [
                  DataCell(Text(item.category ?? '')),
            DataCell(Text(item.itemNumber ?? '')), // <-- 위치 변경
            DataCell(Text(item.title ?? '', overflow: TextOverflow.ellipsis)),
            DataCell(Text('${numberFormatter.format(double.tryParse(item.price ?? '0'))}원')),
            DataCell(Text('${numberFormatter.format(double.tryParse(pricePerPiece))}원')),
            DataCell(Text(item.number ?? '0')), // <-- 추가
            DataCell(Text(item.weight ?? '0')),
            DataCell(Text(item.stock ?? '0')),
            DataCell(Text(item.memo ?? '', overflow: TextOverflow.ellipsis)), // <-- 추가
                ],
                onSelectChanged: (isSelected) {
                  if (isSelected ?? false) {
                    // TODO: Get.to(() => DetailViewScreen(item: item)) 연결
                  }
                },
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('에러 발생: $err')),
      ),
    );
  }
}