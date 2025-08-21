import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../views/screen/add_product_form.dart';
import '../../../views/widgets/price_calculator_dialog.dart';
import '../../viewmodels/goods_list_viewmodel.dart';
import 'add_goods_screen.dart';
import 'goods_detail_screen.dart';

// ... (AddGoodsScreen, DetailViewScreen 등의 import 경로 수정 필요)

class GoodsListScreen extends ConsumerWidget {
  const GoodsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodsListState = ref.watch(goodsListViewModelProvider);
    final selectedCategory = ref.watch(goodsCategoryFilterProvider);
    final numberFormatter = NumberFormat('###,###,###');

    // ViewModel로부터 현재 정렬 상태를 가져옵니다.
    final sortColumnIndex = ref.watch(goodsSortColumnIndexProvider);
    final sortAscending = ref.watch(goodsSortAscendingProvider);

    final List<String> goodsTypeToString = [
      '모든카테고리',
      '과자',
      '사탕',
      '젤리',
      '초콜릿',
      '껌',
      '차,음료',
      '기타',
    ];

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: '상품명, 아이템넘버 검색...',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // 입력값이 바뀔 때마다 검색어 상태를 업데이트합니다.
            ref.read(goodsSearchQueryProvider.notifier).state = value;
          },
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/'),
          icon: const Icon(Icons.home),
        ),
        actions: [
          DropdownButton<String>(
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
              ref
                  .read(goodsListViewModelProvider.notifier)
                  .setCategory(newValue);
            }
          },
        ),
          IconButton(
            tooltip: '제품 생성',
            onPressed: () {
              showAddProductForm(context, ref);
            },
            icon: const Icon(Icons.calculate),
          ),
          IconButton(
            tooltip: '상품 추가',
            onPressed: () {
               Navigator.pushNamed(context, '/addGoods');
            },
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
            // --- 2. DataTable2에 정렬 관련 속성을 추가합니다. ---
            fixedTopRows: 1,
            sortColumnIndex: sortColumnIndex,
            sortAscending: sortAscending,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 1400,// 전체 테이블의 최소 너비를 지정하여 컬럼이 잘리지 않도록 함
            columns: [
              const DataColumn2(label: Text('카테고리'), size: ColumnSize.L),
              // --- 3. 정렬 가능한 컬럼에 onSort 콜백을 추가합니다. ---
              DataColumn2(
                label: const Text('아이템넘버'),
                size: ColumnSize.M,
                onSort: (columnIndex, ascending) {
                  ref.read(goodsSortColumnIndexProvider.notifier).state = columnIndex;
                  ref.read(goodsSortAscendingProvider.notifier).state = ascending;
                },
              ),
              DataColumn2(
                label: const Text('상품명'),
                size: ColumnSize.L,
                onSort: (columnIndex, ascending) {
                  ref.read(goodsSortColumnIndexProvider.notifier).state = columnIndex;
                  ref.read(goodsSortAscendingProvider.notifier).state = ascending;
                },
              ),
              const DataColumn2(
                  label: Text('상품가격'), numeric: true, size: ColumnSize.M),
              const DataColumn2(
                  label: Text('개당가격'), numeric: true, size: ColumnSize.M),
              const DataColumn2(
                  label: Text('상품갯수'),
                  numeric: true,
                  size: ColumnSize.S), // <-- 추가
              const DataColumn2(
                  label: Text('상품무게(g)'),
                  numeric: true,
                  size: ColumnSize.M), // <-- 추가
              const DataColumn2(label: Text('재고'), numeric: true, size: ColumnSize.S),
              const DataColumn2(label: Text('메모'), size: ColumnSize.L), // <-- 추가
            ],
            rows: goods.map((item) {
              // --- 1. 수정 화면으로 이동하는 함수를 정의합니다. ---
        void navigateToEditScreen() {
          Navigator.push(
            context,
            MaterialPageRoute(
              // AddGoodsScreen을 호출하면서 수정할 상품(item) 정보를 전달합니다.
              builder: (context) => AddGoodsScreen(goods: item),
            ),
          );
        }
        
              final pricePerPiece = (double.tryParse(item.price ?? '0')! /
                      double.tryParse(item.number ?? '1')!)
                  .toStringAsFixed(1);

              return DataRow(
                // --- 2. 행을 탭(클릭)했을 때 수정 화면으로 이동하도록 onSelectChanged를 수정합니다. ---
          onSelectChanged: (isSelected) {
            if (isSelected ?? false) {
      // 1. DetailViewScreen으로 이동하도록 수정
      Navigator.push(
        context,
        MaterialPageRoute(
          // DetailViewScreen을 호출하며 상품(item) 정보를 전달
          builder: (context) => GoodsDetailScreen(goods: item),
        ),
      );
    }
  },
                cells: [
                  DataCell(Text(item.category ?? '')),
                  DataCell(Text(item.itemNumber ?? '')), // <-- 위치 변경
                  DataCell(
                      Text(item.title ?? '', overflow: TextOverflow.ellipsis)),
                  DataCell(Text(
                      '${numberFormatter.format(double.tryParse(item.price ?? '0'))}원')),
                  DataCell(Text(
                      '${numberFormatter.format(double.tryParse(pricePerPiece))}원')),
                  DataCell(Text(item.number ?? '0')), // <-- 추가
                  DataCell(Text(item.weight ?? '0')),
                  DataCell(Text(item.stock ?? '0')),
                  DataCell(Text(item.memo ?? '',
                      overflow: TextOverflow.ellipsis)), // <-- 추가
                ],
                
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
