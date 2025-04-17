import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/views/screen/goodsUi/goods_list.dart';
import 'package:stockmanager/views/screen/memoUi/memo_list.dart';
import 'package:stockmanager/views/screen/goodsUi/add_goods.dart';

import 'add_product_form.dart';
import 'productUi/add_product.dart';
import 'productUi/product_list.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          '코스트고 재고관리 1.21',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [

          // 원가계산기
          // IconButton(
          //     onPressed: () {
          //       // setState(() {
          //       //   GoodsPriceCalculator();
          //       // });
          //       AddProductForm();
          //     },
          //     icon: const Icon(Icons.add_task)),

          IconButton(
              onPressed: () {
                Get.to(() => const MemoList());
              },
              icon: const Icon(Icons.add_comment)),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              '상품',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const GoodsList());
                  },
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        '상품리스트',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const AddGoods());
                  },
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        '상품추가',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: (){
                //     // Get.toNamed('/gList');
                //     Get.to(()=>const GoodsList());
                //   },
                //   child: const Text('상품추가', style: TextStyle(
                //     fontSize: 20, fontWeight: FontWeight.bold,
                //   ),),
                // ),
                // const SizedBox(width: 25),
                // TextButton(
                //   onPressed: (){
                //     // Get.toNamed('/gList');
                //     Get.to(()=>const AddGoods());
                //   },
                //   child: const Text('상품추가', style: TextStyle(
                //     fontSize: 20, fontWeight: FontWeight.bold,
                //   ),),
                // ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              '제품',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Get.toNamed('/gList');
                        Get.to(() => const ProductList());
                      },
                      child: const Text(
                        '제품리스트',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    TextButton(
                      onPressed: () {
                        // Get.toNamed('/gList');
                        Get.to(() => const AddProduct());
                      },
                      child: const Text(
                        '제품추가',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
