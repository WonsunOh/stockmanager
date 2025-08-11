import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('코스트고 재고관리'),
        actions: [
          IconButton(
            tooltip: '메모',
            onPressed: () {
              // Get.to(() => const MemoList()); -> Navigator.pushNamed(context, '/memoList');
              Navigator.pushNamed(context, '/memoList');
            },
            icon: const Icon(Icons.add_comment),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Text('상품', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/goodsList'),
                    child: const Text('상품리스트'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/addGoods'),
                    child: const Text('상품추가'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Text('제품', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/productList'),
                    child: const Text('제품리스트'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/addProduct'),
                    child: const Text('제품추가'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}