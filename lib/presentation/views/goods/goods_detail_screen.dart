import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/models/material_model.dart';
import '../../../data/repositories/material_repository.dart';
import 'add_goods_screen.dart';

class GoodsDetailScreen extends ConsumerWidget {
  final MaterialModel material;

  const GoodsDetailScreen({Key? key, required this.material}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormatter = NumberFormat('###,###,###');

    return Scaffold(
      appBar: AppBar(
        title: Text(material.name ?? '상품 상세 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGoodsScreen(material: material),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
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

              if (confirm ?? false) {
                if (material.id == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID가 없어 삭제할 수 없습니다.')),
                    );
                  }
                  return;
                }
                try {
                  await ref.read(materialRepositoryProvider).delete(material.id!);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('삭제 중 오류 발생: $e')),
                    );
                  }
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
            if (material.imageUrl != null && material.imageUrl!.isNotEmpty)
              SizedBox(
                height: 200,
                child: Image.network(
                  material.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            const SizedBox(height: 20),
            _buildDetailRow('상품명', material.name),
            _buildDetailRow('아이템 넘버', material.originalItemNumber),
            _buildDetailRow('카테고리', material.firebaseCategory),
            _buildDetailRow('상품 가격', '${numberFormatter.format(material.price ?? 0)}원'),
            _buildDetailRow('상품 갯수', '${material.quantity ?? 0}'),
            _buildDetailRow('상품 무게', '${material.weight ?? '0'}g'),
            _buildDetailRow('재고', '${material.stockQuantity ?? 0}'),
            _buildDetailRow('메모', material.memo),
            _buildDetailRow('입력일', material.createdAt?.toIso8601String()),
          ],
        ),
      ),
    );
  }

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
