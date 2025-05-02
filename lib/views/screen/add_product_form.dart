import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/controllers/database_controller.dart';
import 'package:stockmanager/controllers/stockmanager_controller.dart';
import 'package:stockmanager/models/product_firebase_model.dart';


class AddProductForm {
  final _formkey = GlobalKey<FormState>();

  var numberComma = NumberFormat('###,###,###');

  final controllVariable = StockmanagerController.to;


  AddProductForm() {
    Get.dialog(
      AlertDialog(
        title: const Text('제품 생성 양식'),
        content: Form(
          key: _formkey,
          child: Obx(
            () => SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: const Text('연관상품코드'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,

                            onChanged: (val) {
                              controllVariable.g_itemNumber.value = val;
                            },
                          )),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: (){
                            if(_formkey.currentState!.validate()){
                              _formkey.currentState?.save();
                              controllVariable.isClickCode.value = true;
                            }

                      }, child: Text('입력')),
                    ],
                  ),

                  const SizedBox(height: 15),
                  if (controllVariable.isClickCode.value)
            FutureBuilder(
        future: relatedGoodsImport(controllVariable.g_itemNumber.value),
          builder: (context, snapshot) {
            return snapshot.hasData?
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
              ),
              child: Column(

                children: [
                  Center(
                    child: Text('구성상품 개요',style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('카테고리'),
                      SizedBox(width: 10),
                      Text(assignToVariable(controllVariable.category.value, (snapshot.data as Map)['카테고리'])),
                      // Text((snapshot.data as Map)['카테고리']),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('구성 상품명'),
                      SizedBox(width: 10),
                      Text(assignToVariable(controllVariable.g_name.value, (snapshot.data as Map)['상품명'])),
                      // Text((snapshot.data as Map)['상품명']),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('개당원가'),
                      SizedBox(width: 10),
                      Text(piecePriceCalculate((snapshot.data as Map)['상품가격'],
                          (snapshot.data as Map)['상품갯수']) + '원'),
                      // Text((int.parse((snapshot.data as Map)['상품가격']) /
                      //     int.parse((snapshot.data as Map)['상품갯수']))
                      // 
                      //     .toStringAsFixed(1))
                      SizedBox(width: 120),
                      Text('개당 무게'),
                      SizedBox(width: 10),
                      Text(pieceWeightCalculate((snapshot.data as Map)['상품무게'],
                          (snapshot.data as Map)['상품갯수']) + 'g'),
                    ],
                  ),

                ],
              ),
            )

                : Center(child: CircularProgressIndicator());


          }

      ),

                  //제품코드
                  Row(
                    children: [
                      const Text('제품코드'),
                      const SizedBox(width: 15),
                      Expanded(
                          child: TextFormField(
                            onChanged: (val) {
                              controllVariable.productNumber.value = val;
                            },
                          )),
                    ],
                  ),
                  //제품명
                  Row(
                    children: [
                      const Text('제품명'),
                      const SizedBox(width: 15),
                      Expanded(
                          child: TextFormField(
                            onChanged: (val) {
                              controllVariable.productName.value = val;
                            },
                          )),
                    ],
                  ),





                  Row(
                    children: [

                      const Text('제품의 갯수'),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                        
                          onChanged: (val) {
                            controllVariable.number.value = val;
                          },
                        ),
                      ),
                    ],
                  ),


                  //수수료율
                  Row(
                    children: [
                      const Text('수수료율'),
                      const SizedBox(width: 15),
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        onChanged: (val) {
                          controllVariable.commissionRate.value = val;
                        },
                      )),
                    ],
                  ),
                  //수익률
                  Row(
                    children: [
                      const Text('수익률'),
                      const SizedBox(width: 15),
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        onChanged: (val) {
                          controllVariable.earningRate.value = val;
                        },
                      )),
                    ],
                  ),

                  //배송방법 TextFormField
                  Row(
                    children: [
                      const Text('배송방법'),
                      const SizedBox(width: 15),
                      DropdownButton<String>(
                        value: controllVariable.dropdownValue.value,
                        items: controllVariable.deliveryList
                            .map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (val) {
                          controllVariable.setSelected(val!);
                        },
                      ),

                      //무료배송이면 배송비 입력란이 나오게
                      if (controllVariable.dropdownValue == '무료배송')
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                width: 60,
                                child: const Text('배송비'),
                              ),

                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                                ],
                                onChanged: (val) {
                                  controllVariable.deliveryCharge.value =
                                      val;
                                },
                              )),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState?.save();
                        controllVariable.isClick.value = true;
                      }

                      productCostCalculate(
                          controllVariable.itemCost.value,
                          controllVariable.number.value).toString();
                      productWeightCalculate(controllVariable.itemWeight.value,
                          controllVariable.number.value);
                      sellingPriceCalculate(
                              controllVariable.productCost.value,
                              controllVariable.earningRate.value,
                              controllVariable.commissionRate.value,
                              controllVariable.deliveryCharge.value)
                          .toString();
                      commissionCalaulate(
                          controllVariable.commissionRate.value).toString();
                      earningCalaulate(
                          controllVariable.earningRate.value).toString();


                    },
                    child: const Text('판매가 계산'),
                  ),
                  const SizedBox(height: 15),
                  if (controllVariable.isClick.value)
                    Column(
                      children: [
                        calculateResult('제품원가',
                            numberComma.format(int.parse(
                              controllVariable.productCost.value
                            ))),
                        Row(
                          children: [
                            Text('제품무게'),
                            SizedBox(width: 10),
                            Text(numberComma.format(int.parse(
                              controllVariable.productWeight.value)) + 'g'),
                          ],),
                        Row(
                          children: [
                            Text('배송방법'),
                            SizedBox(width: 10),
                            Text(controllVariable.dropdownValue.value)
                          ],
                        ),
                        calculateResult(
                            '제품판매가',
                            numberComma.format(int.parse(
                                controllVariable.sellingPrice.value))),
                        Row(
                          children: [
                            calculateResult(
                                '수수료',
                                numberComma.format(int.parse(
                                    controllVariable.commission.value))),
                            SizedBox(width: 5),
                            Text('(' + controllVariable.commissionRate.value + '%)')
                          ],
                        ),
                        Row(
                          children: [
                            calculateResult(
                                '수익',
                                numberComma.format(int.parse(
                                    controllVariable.earning.value))),
                            SizedBox(width: 5),
                            Text('(' + controllVariable.earningRate.value + '%)')
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if(_formkey.currentState!.validate()) {
                            _formkey.currentState?.save();
                            await DatabaseController.to
                                .addProductStock(ProductFirebaseModel(
                              title: controllVariable.productName.value,  //제품명
                              itemNumber: controllVariable.productNumber.value, //제품 코드
                              category: controllVariable.category.value,  //카테고리
                              g_itemNumber: controllVariable.g_itemNumber.value,  //연관상품코드
                              g_title: controllVariable.g_name.value, //구성 상품명
                              p_price: controllVariable.itemCost.value, //개당 원가
                              costPrice: controllVariable.productCost.value, //제품 원가
                              number: controllVariable.number.value, //제품의 갯수
                              weight: controllVariable.productWeight.value //제품 무게


                            ));
                          }


                        },
                        child: const Text('제품추가'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();

                        },
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  //연관상품 불러오기
  relatedGoodsImport(String docData) async {
    var itemData = await FirebaseFirestore.instance.collection('goodsData')
        .doc(docData)
        .get();
    return itemData.data();
  }

  //개당 계산기
  piecePerCalculate(String cost, String goodsCount, var value ) {
    value = (int.parse(cost) /
        int.parse(goodsCount))
        .toStringAsFixed(1);
    return value;
  }
  //개당 가격 계산기
  piecePriceCalculate(String cost, String goodsCount ) {
    controllVariable.itemCost.value = (int.parse(cost) /
        int.parse(goodsCount))
        .toStringAsFixed(1);
    return controllVariable.itemCost.value;
  }

  pieceWeightCalculate(String weight, String goodsCount) {
    controllVariable.itemWeight.value = (int.parse(weight) /
        int.parse(goodsCount))
        .toStringAsFixed(1);
    return controllVariable.itemWeight.value;
  }


  //제품 원가 계산기
  productCostCalculate(String itemCost, String itemNumber) {
    controllVariable.productCost.value = ((double.parse(itemCost) *
        int.parse(itemNumber)).round()).toString();
    return controllVariable.productCost.value;

  }

  //제품무게 계산기
  productWeightCalculate (String item, String number) {
    controllVariable.productWeight.value = (double.parse(item) *
        int.parse(number)).toString();
    return controllVariable.productWeight.value;
  }

  //불러온 결과 변수에 할당하기
  assignToVariable (String variable, String input) {
    variable = input;
    return variable;
  }



  //판매가 계산기
  sellingPriceCalculate(String costPrice, String earningRate,
      String commissionRate, String deliveryCharge) {
    if (controllVariable.dropdownValue.value == '유료배송') {
      controllVariable.sellingPrice.value = ((((int.parse(costPrice) /
                          (1 -
                              int.parse(earningRate) / 100 -
                              int.parse(commissionRate) / 100)) /
                      10)
                  .round()) *
              10)
          .toString();
    } else if (controllVariable.dropdownValue.value == '무료배송') {
      controllVariable.sellingPrice.value =
          (((((int.parse(costPrice) + int.parse(deliveryCharge)) /
                              (1 -
                                  int.parse(earningRate) / 100 -
                                  int.parse(commissionRate) / 100)) /
                          10)
                      .round()) *
                  10)
              .toString();
    }
    return controllVariable.sellingPrice.value;
  }

  //수수료 계산기
  commissionCalaulate(String commissionRate) {
    controllVariable.commission.value =
        ((((int.parse(controllVariable.sellingPrice.value) *
                            (int.parse(commissionRate) / 100)) /
                        10)
                    .round()) *
                10)
            .toString();
    return controllVariable.commission.value;
  }

  //수익 계산기
  earningCalaulate(String earningRate) {
    controllVariable.earning.value =
        ((((int.parse(controllVariable.sellingPrice.value) *
                            (int.parse(earningRate) / 100)) /
                        10)
                    .round()) *
                10)
            .toString();
    return controllVariable.earning.value;
  }

  Widget calculateResult(String title, String result) {
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 15),
        Text('$result 원'),
      ],
    );
  }
}

// class DeliveryDropdownButton extends StatefulWidget {
//   const DeliveryDropdownButton({Key? key}) : super(key: key);
//
//   @override
//   State<DeliveryDropdownButton> createState() => _DeliveryDropdownButtonState();
// }
//
// class _DeliveryDropdownButtonState extends State<DeliveryDropdownButton> {
//   final List<String> DeliveryList = ['배송선택', '유료배송', '무료배송'];
//   String? dropdownValue = '배송선택';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text('배송방법'),
//           SizedBox(width: 15),
//           Expanded(
//             child: DropdownButton<String>(
//               items: DeliveryList.map<DropdownMenuItem<String>>((String item) {
//                 return DropdownMenuItem(
//                   value: item,
//                   child: Text('$item'),
//                 );
//               }).toList(),
//               onChanged: (String? val) {
//                 setState(() {
//                   dropdownValue = val;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
