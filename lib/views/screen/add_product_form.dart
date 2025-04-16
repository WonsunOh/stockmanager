import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/controllers/stockmanager_controller.dart';


class AddProductForm {
  final __formkey = GlobalKey<FormState>();

  var numberComma = NumberFormat('###,###,###');

  AddProductForm() {
    Get.dialog(
      AlertDialog(
        title: const Text('제품 생성 양식 V1.0'),
        content: Form(
          key: __formkey,
          child: Obx(
            () => SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //제품명
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: const Text('제품명'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,

                            onChanged: (val) {
                              StockmanagerController.to.productName.value = val;
                            },
                          )),
                    ],
                  ),

                  //카테고리
                  Row(
                    children: [
                      const Text('카테고리'),
                      const SizedBox(width: 15),
                      DropdownButton<String>(
                        value: StockmanagerController.to.categroyValue.value,
                        items: StockmanagerController.to.productCategroy
                            .map<DropdownMenuItem<String>>((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (val) {
                          StockmanagerController.to.setCategorySelected(val!);
                        },
                      ),

                      SizedBox(width: 30),
                      //상품코드
                      Container(
                        alignment: Alignment.centerRight,
                        width: 90,
                        child: const Text('연관상품코드'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,

                          onChanged: (val) {
                            StockmanagerController.to.itemNumber.value = val;
                          },
                        ),
                      ),


                    ],
                  ),


                  Row(
                    children: [
                      //개당원가
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: const Text('개당원가'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,

                          onChanged: (val) {
                            StockmanagerController.to.itemCost.value = val;
                          },
                        ),
                      ),
                      SizedBox(width: 10),

                      Container(
                        alignment: Alignment.centerRight,
                        width: 90,
                        child: const Text('상품의 갯수'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                        
                          onChanged: (val) {
                            StockmanagerController.to.itemNumber.value = val;
                          },
                        ),
                      ),
                    ],
                  ),


                  //수수료율
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: const Text('수수료율'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        onChanged: (val) {
                          StockmanagerController.to.commissionRate.value = val;
                        },
                      )),
                    ],
                  ),
                  //수익률
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: const Text('수익률'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        onChanged: (val) {
                          StockmanagerController.to.earningRate.value = val;
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
                        value: StockmanagerController.to.dropdownValue.value,
                        items: StockmanagerController.to.deliveryList
                            .map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (val) {
                          StockmanagerController.to.setSelected(val!);
                        },
                      ),

                      //무료배송이면 배송비 입력란이 나오게
                      if (StockmanagerController.to.dropdownValue == '무료배송')
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
                                  StockmanagerController.to.deliveryCharge.value =
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
                      if (__formkey.currentState!.validate()) {
                        __formkey.currentState?.save();
                        StockmanagerController.to.isClick.value = true;
                      }
                      productCostCalculate(
                          StockmanagerController.to.itemCost.value,
                          StockmanagerController.to.itemNumber.value).toString();
                      sellingPriceCalculate(
                              StockmanagerController.to.productCost.value,
                              StockmanagerController.to.earningRate.value,
                              StockmanagerController.to.commissionRate.value,
                              StockmanagerController.to.deliveryCharge.value)
                          .toString();
                      commissionCalaulate(
                          StockmanagerController.to.commissionRate.value);
                      earningCalaulate(
                          StockmanagerController.to.earningRate.value);
                    },
                    child: const Text('판매가 계산'),
                  ),
                  const SizedBox(height: 15),
                  if (StockmanagerController.to.isClick.value)
                    Column(
                      children: [
                        calculateResult('제품원가',
                            numberComma.format(int.parse(
                              StockmanagerController.to.productCost.value
                            ))),
                        calculateResult(
                            '제품판매가',
                            numberComma.format(int.parse(
                                StockmanagerController.to.sellingPrice.value))),
                        calculateResult(
                            '수수료',
                            numberComma.format(int.parse(
                                StockmanagerController.to.commission.value))),
                        calculateResult(
                            '수익',
                            numberComma.format(int.parse(
                                StockmanagerController.to.earning.value))),
                      ],
                    ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('닫기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //제품 원가 계산기
  productCostCalculate(String itemCost, String itemNumber) {
    StockmanagerController.to.productCost.value = (int.parse(itemCost).round() *
        int.parse(itemNumber)).toString();

  }

  //판매가 계산기
  sellingPriceCalculate(String costPrice, String earningRate,
      String commissionRate, String deliveryCharge) {
    if (StockmanagerController.to.dropdownValue.value == '유료배송') {
      StockmanagerController.to.sellingPrice.value = ((((int.parse(costPrice) /
                          (1 -
                              int.parse(earningRate) / 100 -
                              int.parse(commissionRate) / 100)) /
                      10)
                  .round()) *
              10)
          .toString();
    } else if (StockmanagerController.to.dropdownValue.value == '무료배송') {
      StockmanagerController.to.sellingPrice.value =
          (((((int.parse(costPrice) + int.parse(deliveryCharge)) /
                              (1 -
                                  int.parse(earningRate) / 100 -
                                  int.parse(commissionRate) / 100)) /
                          10)
                      .round()) *
                  10)
              .toString();
    }
    return StockmanagerController.to.sellingPrice.value;
  }

  //수수료 계산기
  commissionCalaulate(String commissionRate) {
    StockmanagerController.to.commission.value =
        ((((int.parse(StockmanagerController.to.sellingPrice.value) *
                            (int.parse(commissionRate) / 100)) /
                        10)
                    .round()) *
                10)
            .toString();
  }

  //수익 계산기
  earningCalaulate(String earningRate) {
    StockmanagerController.to.earning.value =
        ((((int.parse(StockmanagerController.to.sellingPrice.value) *
                            (int.parse(earningRate) / 100)) /
                        10)
                    .round()) *
                10)
            .toString();
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
