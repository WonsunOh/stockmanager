import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// `product_repository.dart` 파일이 있다고 가정합니다. 이 파일은 Riverpod Provider를 통해 제공되어야 합니다.
// 예: final productRepositoryProvider = Provider((ref) => ProductRepository());
import 'package:stockmanager/data/repositories/product_repository.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';

void showAddProductForm(BuildContext context, WidgetRef ref) {
  final formKey = GlobalKey<FormState>();
  final numberFormatter = NumberFormat('###,###,###');

  // 1. 각 입력 필드에 대한 컨트롤러를 생성합니다.
  final relatedGoodsIdController = TextEditingController();
  final productNumberController = TextEditingController();
  final productNameController = TextEditingController();
  final numberOfPiecesController = TextEditingController();
  final commissionRateController = TextEditingController();
  final earningRateController = TextEditingController();
  final deliveryChargeController = TextEditingController(text: '0');

  String deliveryMethod = '유료배송';
  Map<String, dynamic>? relatedGoodsData;
  Map<String, String> calculationResults = {};
  bool calculateClicked = false;
  bool findGoodsClicked = false;

  // 연관상품 불러오기
  Future<Map<String, dynamic>> _fetchRelatedGoods(String docId) async {
    if (docId.isEmpty) {
      throw Exception('상품 코드를 입력해주세요.');
    }
    final doc =
        await FirebaseFirestore.instance.collection('goodsData').doc(docId).get();
    if (!doc.exists) throw Exception('상품을 찾을 수 없습니다.');
    return doc.data()!;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          
          void _calculate() {
            // 2. 컨트롤러의 .text 속성으로 최신 값을 직접 가져옵니다.
            if (relatedGoodsData == null ||
                numberOfPiecesController.text.isEmpty ||
                commissionRateController.text.isEmpty ||
                earningRateController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('연관상품 및 계산 값을 모두 입력해주세요.')),
              );
              return;
            }

            final goodsPrice = double.tryParse(relatedGoodsData!['상품가격'] ?? '0') ?? 0.0;
            final goodsNumber = double.tryParse(relatedGoodsData!['상품갯수'] ?? '1') ?? 1.0;
            final goodsWeight = double.tryParse(relatedGoodsData!['상품무게'] ?? '0') ?? 0.0;

            final piecePrice = goodsPrice / goodsNumber;
            final pieceWeight = goodsWeight / goodsNumber;

            final pieces = int.tryParse(numberOfPiecesController.text) ?? 0;
            final cRate = (double.tryParse(commissionRateController.text) ?? 0.0) / 100;
            final eRate = (double.tryParse(earningRateController.text) ?? 0.0) / 100;
            final dCharge = double.tryParse(deliveryChargeController.text) ?? 0.0;

            final productCost = piecePrice * pieces;
            final productWeight = pieceWeight * pieces;

            double sellingPrice = 0;
            if (deliveryMethod == '유료배송') {
              sellingPrice = productCost / (1 - eRate - cRate);
            } else {
              sellingPrice = (productCost + dCharge) / (1 - eRate - cRate);
            }
            // 1의 자리에서 반올림
            sellingPrice = (sellingPrice / 10).round() * 10;
            
            final commission = sellingPrice * cRate;
            final earning = sellingPrice * eRate;
            
            setState(() {
              calculationResults = {
                'piecePrice': piecePrice.toStringAsFixed(1),
                'pieceWeight': pieceWeight.toStringAsFixed(1),
                'productCost': productCost.round().toString(),
                'productWeight': productWeight.toStringAsFixed(1),
                'sellingPrice': sellingPrice.round().toString(),
                'commission': commission.round().toString(),
                'earning': earning.round().toString(),
              };
              calculateClicked = true;
            });
          }

          void _addProduct() async {
            if (formKey.currentState!.validate() && calculateClicked) {
              final product = ProductFirebaseModel(
                title: productNameController.text,
                itemNumber: productNumberController.text,
                category: relatedGoodsData!['카테고리'],
                g_itemNumber: relatedGoodsIdController.text,
                g_title: relatedGoodsData!['상품명'],
                p_price: calculationResults['piecePrice'],
                costPrice: calculationResults['productCost'],
                number: numberOfPiecesController.text,
                weight: calculationResults['productWeight'],
                commissionRate: commissionRateController.text,
                earningRate: earningRateController.text,
                deliveryMethod: deliveryMethod,
                price: calculationResults['sellingPrice'],
                commission: calculationResults['commission'],
                earning: calculationResults['earning'],
                inputDay: DateTime.now().toString(),
                stock: '0', // 초기 재고는 0으로 설정
                memo: '', // 초기 메모는 비워둠
              );

              try {
                // Riverpod를 사용하여 데이터 추가
                await ref.read(productRepositoryProvider).saveProduct(product);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('제품이 성공적으로 추가되었습니다.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('오류 발생: $e')),
                );
              }
            } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('폼을 모두 채우고 판매가 계산을 먼저 실행해주세요.')),
                );
            }
          }

          return AlertDialog(
            title: const Text('제품 생성 및 판매가 계산'),
            content: Form(
              key: formKey,
              child: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('연관상품코드')),
                          const SizedBox(width: 10),
                          // 3. 컨트롤러를 TextFormField에 연결합니다.
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: relatedGoodsIdController,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                            )
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                                if (relatedGoodsIdController.text.isNotEmpty) {
                                    setState(() => findGoodsClicked = true);
                                }
                            },
                            child: const Text('찾기'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),

                      if (findGoodsClicked)
                        FutureBuilder<Map<String, dynamic>>(
                          future: _fetchRelatedGoods(relatedGoodsIdController.text),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('오류: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                            }
                            if (snapshot.hasData) {
                                relatedGoodsData = snapshot.data;
                                final goodsPrice = double.parse(relatedGoodsData!['상품가격']);
                                final goodsNumber = double.parse(relatedGoodsData!['상품갯수']);
                                final goodsWeight = double.parse(relatedGoodsData!['상품무게']);
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                    child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Center(child: Text('구성상품 정보', style: TextStyle(fontWeight: FontWeight.bold))),
                                        Text("카테고리: ${relatedGoodsData!['카테고리']}"),
                                        Text("상품명: ${relatedGoodsData!['상품명']}"),
                                        Text("개당원가: ${(goodsPrice / goodsNumber).toStringAsFixed(1)}원"),
                                        Text("개당무게: ${(goodsWeight / goodsNumber).toStringAsFixed(1)}g"),
                                    ],
                                    ),
                                );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                      TextFormField(
                        controller: productNumberController,
                        decoration: const InputDecoration(labelText: '제품코드'),
                        validator: (val) => val!.isEmpty ? '제품코드를 입력하세요.' : null,
                      ),
                      TextFormField(
                        controller: productNameController,
                        decoration: const InputDecoration(labelText: '제품명'),
                        validator: (val) => val!.isEmpty ? '제품명을 입력하세요.' : null,
                      ),
                      TextFormField(
                        controller: numberOfPiecesController,
                        decoration: const InputDecoration(labelText: '제품의 갯수'),
                        keyboardType: TextInputType.number,
                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      TextFormField(
                        controller: commissionRateController,
                        decoration: const InputDecoration(labelText: '수수료율(%)'),
                        keyboardType: TextInputType.number,
                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      TextFormField(
                        controller: earningRateController,
                        decoration: const InputDecoration(labelText: '수익률(%)'),
                        keyboardType: TextInputType.number,
                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      
                      Row(
                        children: [
                            const Text('배송방법'),
                            const SizedBox(width: 15),
                            DropdownButton<String>(
                                value: deliveryMethod,
                                items: ['유료배송', '무료배송'].map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                    );
                                }).toList(),
                                onChanged: (newValue) {
                                    setState(() {
                                        deliveryMethod = newValue!;
                                        if (newValue == '유료배송') {
                                            deliveryChargeController.text = '0';
                                        }
                                    });
                                },
                            ),
                            if (deliveryMethod == '무료배송')
                            Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                    controller: deliveryChargeController,
                                    decoration: const InputDecoration(labelText: '배송비'),
                                    keyboardType: TextInputType.number,
                                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                                ),
                            ),
                        ],
                      ),

                      if(calculateClicked)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                             padding: const EdgeInsets.all(10),
                             decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                             child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(child: Text('계산 결과', style: TextStyle(fontWeight: FontWeight.bold))),
                                  Text('제품원가: ${numberFormatter.format(double.parse(calculationResults['productCost']!))}원'),
                                  Text('제품무게: ${calculationResults['productWeight']}g'),
                                  Text('판매가: ${numberFormatter.format(double.parse(calculationResults['sellingPrice']!))}원'),
                                  Text('수수료: ${numberFormatter.format(double.parse(calculationResults['commission']!))}원 (${commissionRateController.text}%)'),
                                  Text('수익: ${numberFormatter.format(double.parse(calculationResults['earning']!))}원 (${earningRateController.text}%)'),
                                ],
                             ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
             actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('닫기')),
                ElevatedButton(onPressed: _calculate, child: const Text('판매가 계산')),
                ElevatedButton(onPressed: _addProduct, child: const Text('제품 추가')),
             ],
          );
        },
      );
    },
  );
}