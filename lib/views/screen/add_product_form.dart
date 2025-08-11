import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/data/repositories/product_repository.dart'; // Product 저장을 위해 Repository 사용
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart'; // Repository를 가져오기 위해 riverpod 사용

// 클래스 형태가 아닌, 위젯을 보여주는 함수 형태로 변경
void showAddProductForm(BuildContext context, WidgetRef ref) {
  final formKey = GlobalKey<FormState>();
  final numberFormatter = NumberFormat('###,###,###');

  // 다이얼로그 내부에서만 사용할 상태 변수들
  String relatedGoodsId = '';
  bool findGoodsClicked = false;
  
  String productNumber = '';
  String productName = '';
  String numberOfPieces = '';
  String commissionRate = '';
  String earningRate = '';
  String deliveryMethod = '유료배송';
  String deliveryCharge = '0';
  
  Map<String, dynamic>? relatedGoodsData;
  Map<String, String> calculationResults = {};
  bool calculateClicked = false;

  // 연관상품 불러오기
  Future<Map<String, dynamic>> _fetchRelatedGoods(String docId) async {
    final doc = await FirebaseFirestore.instance.collection('goodsData').doc(docId).get();
    return doc.data()!;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // 다이얼로그 내부의 상태 변경을 위해 StatefulBuilder 사용
      return StatefulBuilder(
        builder: (context, setState) {
          
          // 계산 로직
          void calculate() {
            if (relatedGoodsData == null) return;

            final itemCost = double.parse(relatedGoodsData!['상품가격']) / double.parse(relatedGoodsData!['상품갯수']);
            final itemWeight = double.parse(relatedGoodsData!['상품무게']) / double.parse(relatedGoodsData!['상품갯수']);
            
            final productCost = (itemCost * int.parse(numberOfPieces));
            final productWeight = (itemWeight * int.parse(numberOfPieces));
            
            double sellingPrice;
            final costForCalc = deliveryMethod == '무료배송' 
                ? productCost + double.parse(deliveryCharge) 
                : productCost;
            
            final denominator = 1 - (double.parse(earningRate)/100) - (double.parse(commissionRate)/100);
            sellingPrice = costForCalc / denominator;
            sellingPrice = (sellingPrice / 10).round() * 10.0;

            final commission = (sellingPrice * (double.parse(commissionRate) / 100)).round();
            final earning = (sellingPrice * (double.parse(earningRate) / 100)).round();

            setState(() {
              calculationResults = {
                'productCost': productCost.toString(),
                'productWeight': productWeight.toString(),
                'sellingPrice': sellingPrice.round().toString(),
                'commission': commission.toString(),
                'earning': earning.toString(),
              };
              calculateClicked = true;
            });
          }

          // 제품 추가 로직
          void addProduct() async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              
              final product = ProductFirebaseModel(
                  title: productName,
                  itemNumber: productNumber,
                  category: relatedGoodsData!['카테고리'],
                  g_itemNumber: relatedGoodsId,
                  g_title: relatedGoodsData!['상품명'],
                  p_price: (double.parse(relatedGoodsData!['상품가격']) / double.parse(relatedGoodsData!['상품갯수'])).toStringAsFixed(1),
                  costPrice: calculationResults['productCost'],
                  number: numberOfPieces,
                  weight: calculationResults['productWeight'],
                  price: calculationResults['sellingPrice'],
                  commission: calculationResults['commission'],
                  earning: calculationResults['earning'],
                  // ... 기타 필요한 필드 추가
              );

              // Riverpod을 통해 Repository 인스턴스를 가져와서 데이터 저장
              await ref.read(productRepositoryProvider).saveProduct(product);
              
              Navigator.of(context).pop();
            }
          }

          return AlertDialog(
            title: const Text('제품 생성 양식'),
            content: Form(
              key: formKey,
              child: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 연관상품코드 입력
                      Row(
                        children: [
                          const Text('연관상품코드'),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              onSaved: (val) => relatedGoodsId = val!,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              formKey.currentState!.save();
                              setState(() {
                                findGoodsClicked = true;
                              });
                            },
                            child: const Text('입력'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 연관상품 정보 표시
                      if (findGoodsClicked)
                        FutureBuilder<Map<String, dynamic>>(
                          future: _fetchRelatedGoods(relatedGoodsId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Text('상품을 찾을 수 없습니다.', style: TextStyle(color: Colors.red));
                            }
                            relatedGoodsData = snapshot.data;
                            final costPerPiece = (double.parse(relatedGoodsData!['상품가격']) / double.parse(relatedGoodsData!['상품갯수'])).toStringAsFixed(1);
                            final weightPerPiece = (double.parse(relatedGoodsData!['상품무게']) / double.parse(relatedGoodsData!['상품갯수'])).toStringAsFixed(1);
                            
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                              child: Column(
                                children: [
                                  Text('구성상품: ${relatedGoodsData!['상품명']}'),
                                  Text('개당원가: $costPerPiece 원 / 개당무게: $weightPerPiece g'),
                                ],
                              ),
                            );
                          },
                        ),

                      // 제품 정보 입력 필드들...
                      TextFormField(decoration: const InputDecoration(labelText: '제품코드'), onSaved: (val) => productNumber = val!),
                      TextFormField(decoration: const InputDecoration(labelText: '제품명'), onSaved: (val) => productName = val!),
                      TextFormField(decoration: const InputDecoration(labelText: '제품의 갯수'), keyboardType: TextInputType.number, onSaved: (val) => numberOfPieces = val!),
                      TextFormField(decoration: const InputDecoration(labelText: '수수료율(%)'), keyboardType: TextInputType.number, onSaved: (val) => commissionRate = val!),
                      TextFormField(decoration: const InputDecoration(labelText: '수익률(%)'), keyboardType: TextInputType.number, onSaved: (val) => earningRate = val!),
                      
                      DropdownButton<String>(
                        value: deliveryMethod,
                        items: ['유료배송', '무료배송'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (val) => setState(() => deliveryMethod = val!),
                      ),

                      if(deliveryMethod == '무료배송')
                        TextFormField(decoration: const InputDecoration(labelText: '배송비(원)'), keyboardType: TextInputType.number, onSaved: (val) => deliveryCharge = val!),

                      const SizedBox(height: 15),
                      ElevatedButton(onPressed: calculate, child: const Text('판매가 계산')),
                      
                      // 계산 결과 표시
                      if (calculateClicked)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                                Text('제품원가: ${numberFormatter.format(double.parse(calculationResults['productCost']!))} 원'),
                                Text('판매가: ${numberFormatter.format(double.parse(calculationResults['sellingPrice']!))} 원'),
                                //...
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: addProduct, child: const Text('제품추가')),
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('닫기')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}