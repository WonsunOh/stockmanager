import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/category_repository.dart';
import '../../../views/widgets/price_calculator_dialog.dart';
import '../../viewmodels/goods_list_viewmodel.dart';
import '../../widgets/category_cascade_dropdown.dart';
import 'add_goods_screen.dart';
import 'goods_detail_screen.dart';

class GoodsListScreen extends ConsumerWidget {
  const GoodsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goodsListState = ref.watch(goodsListViewModelProvider);
    final treeAsync = ref.watch(categoryTreeProvider);
    final numberFormatter = NumberFormat('###,###,###');

    final sortColumnIndex = ref.watch(goodsSortColumnIndexProvider);
    final sortAscending = ref.watch(goodsSortAscendingProvider);

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
            ref.read(goodsSearchQueryProvider.notifier).state = value;
          },
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/'),
          icon: const Icon(Icons.home),
        ),
        actions: [
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: CategoryCascadeDropdown(
              key: ValueKey(ref.watch(goodsCategoryFilterIdProvider)),
              initialCategoryId: ref.watch(goodsCategoryFilterIdProvider),
              allowAllAtRoot: true,
              onChanged: (id) {
                ref.read(goodsCategoryFilterIdProvider.notifier).state = id;
              },
            ),
          ),
          Expanded(
            child: goodsListState.when(
              data: (goods) => DataTable2(
                fixedTopRows: 1,
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 1500,
                columns: [
                  const DataColumn2(label: Text('카테고리'), size: ColumnSize.L),
                  DataColumn2(
                    label: const Text('아이템넘버'),
                    size: ColumnSize.M,
                    onSort: (i, asc) {
                      ref.read(goodsSortColumnIndexProvider.notifier).state = i;
                      ref.read(goodsSortAscendingProvider.notifier).state = asc;
                    },
                  ),
                  DataColumn2(
                    label: const Text('상품명'),
                    size: ColumnSize.L,
                    onSort: (i, asc) {
                      ref.read(goodsSortColumnIndexProvider.notifier).state = i;
                      ref.read(goodsSortAscendingProvider.notifier).state = asc;
                    },
                  ),
                  const DataColumn2(label: Text('상품가격'), numeric: true, size: ColumnSize.M),
                  const DataColumn2(label: Text('개당가격'), numeric: true, size: ColumnSize.M),
                  const DataColumn2(label: Text('상품갯수'), numeric: true, size: ColumnSize.S),
                  const DataColumn2(label: Text('상품무게(g)'), numeric: true, size: ColumnSize.M),
                  const DataColumn2(label: Text('재고'), numeric: true, size: ColumnSize.S),
                  const DataColumn2(label: Text('메모'), size: ColumnSize.L),
                ],
                rows: goods.map((item) {
                  final price = item.price ?? 0;
                  final qty = item.quantity ?? 0;
                  final pricePerPiece = qty == 0 ? 0 : price / qty;
                  final categoryPath = treeAsync.maybeWhen(
                    data: (tree) => tree.pathString(item.categoryId),
                    orElse: () => item.firebaseCategory ?? '',
                  );

                  return DataRow(
                    onSelectChanged: (isSelected) {
                      if (isSelected ?? false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GoodsDetailScreen(material: item),
                          ),
                        );
                      }
                    },
                    cells: [
                      DataCell(Text(categoryPath, overflow: TextOverflow.ellipsis)),
                      DataCell(Text(item.originalItemNumber ?? '')),
                      DataCell(Text(item.name ?? '', overflow: TextOverflow.ellipsis)),
                      DataCell(Text('${numberFormatter.format(price)}원')),
                      DataCell(Text('${numberFormatter.format(pricePerPiece)}원')),
                      DataCell(Text('${item.quantity ?? 0}')),
                      DataCell(Text(item.weight ?? '0')),
                      DataCell(Text('${item.stockQuantity ?? 0}')),
                      DataCell(Text(item.memo ?? '', overflow: TextOverflow.ellipsis)),
                    ],
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('에러 발생: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '상품 추가',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddGoodsScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
