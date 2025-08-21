import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/models/goods_firebase_model.dart';
import 'package:stockmanager/data/repositories/goods_repository.dart';
import 'package:stockmanager/presentation/views/goods/add_goods_screen.dart';

class GoodsDetailScreen extends ConsumerWidget {
  final GoodsFirebaseModel goods;

  const GoodsDetailScreen({Key? key, required this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goods.title ?? '상품 상세 정보'),
        actions: [
          // 수정 버튼
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement( // 수정 후 돌아왔을 때 화면을 갱신하기 위해 pushReplacement 사용
                context,
                MaterialPageRoute(
                  builder: (context) => AddGoodsScreen(goods: goods),
                ),
              );
            },
          ),
          // 삭제 버튼
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // 사용자에게 삭제 확인 다이얼로그 표시
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('삭제 확인'),
                  content: const Text('정말로 이 상품을 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );

              // 사용자가 '삭제'를 눌렀을 경우
              if (confirm ?? false) {
                try {
                  await ref.read(goodsRepositoryProvider).deleteGoods(goods.itemNumber!);
                  if (context.mounted) {
                    Navigator.of(context).pop(); // 상세 화면 닫기
                  }
                } catch (e) {
                  // 에러 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('삭제 중 오류 발생: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 여러 이미지들을 가로로 스크롤하여 보여주는 위젯
            if (goods.imageUrls != null && goods.imageUrls!.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: goods.imageUrls!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        goods.imageUrls![index],
                        fit: BoxFit.cover,
                        width: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 100),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            _buildDetailRow('상품명', goods.title),
            _buildDetailRow('아이템 넘버', goods.itemNumber),
            _buildDetailRow('카테고리', goods.category),
            _buildDetailRow('상품 가격', '${goods.price}원'),
            _buildDetailRow('상품 갯수', goods.number),
            _buildDetailRow('상품 무게', '${goods.weight}g'),
            _buildDetailRow('재고', goods.stock),
            _buildDetailRow('메모', goods.memo),
            _buildDetailRow('입력일', goods.inputDay),
          ],
        ),
      ),
    );
  }

  // 상세 정보를 보여주는 행을 만드는 헬퍼 위젯
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }
}