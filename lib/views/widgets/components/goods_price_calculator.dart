import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/controllers/stockmanager_controller.dart';
import 'package:stockmanager/views/screen/sale_home.dart';

// class GoodsPriceCalculator {
//   @override
//   GoodsPriceCalculator() {
//     input_text(String title) {
//       return Row(
//         children: [
//           Text(title),
//           SizedBox(width: 15),
//           Expanded(
//               child: TextFormField(
//             onChanged: (val) {},
//           )),
//         ],
//       );
//     }
//
//     String? dropdownValue = '배송선택';
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return AlertDialog(
//                 title: Text('상품 판매가 계산기 V1.0'),
//                 content: Form(
//                   child: Container(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         input_text('원가'),
//                         input_text('수수료율'),
//                         input_text('수익률'),
//                         Row(
//                           children: [
//                             Text('배송방법'),
//                             SizedBox(width: 15),
//                             DropdownButton<String>(
//                               items: ['배송선택', '유료배송', '무료배송']
//                                   .map<DropdownMenuItem<String>>((String item) {
//                                 return DropdownMenuItem(
//                                   value: item,
//                                   child: Text('$item'),
//                                 );
//                               }).toList(),
//                               onChanged: (String? val) {
//                                 setState(() {
//                                   dropdownValue = val;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }
// }

class GoodsPriceCalculator {
  final _formkey = GlobalKey<FormState>();

  var numberComma = NumberFormat('###,###,###');

  @override
  GoodsPriceCalculator() {
    Get.dialog(
      AlertDialog(
        title: Text('상품 판매가 계산기 V1.0'),
        content: Form(
          key: _formkey,
          child: Obx(
            () => Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //원가
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: Text('원가'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        onChanged: (val) {
                          StockmanagerController.to.costPrice.value = val;
                        },
                      )),
                    ],
                  ),
                  //수수료율
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: 60,
                        child: Text('수수료율'),
                      ),
                      SizedBox(width: 10),
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
                        child: Text('수익률'),
                      ),
                      SizedBox(width: 10),
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
                      Text('배송방법'),
                      SizedBox(width: 15),
                      DropdownButton<String>(
                        value: StockmanagerController.to.dropdownValue.value,
                        items: StockmanagerController.to.deliveryList
                            .map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text('$item'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          StockmanagerController.to.setSelected(val!);
                        },
                      ),
                    ],
                  ),
                  //무료배송이면 배송비 입력란이 나오게
                  if (StockmanagerController.to.dropdownValue == '무료배송')
                    //배송비
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: 60,
                          child: Text('배송비'),
                        ),
                        SizedBox(width: 10),
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
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState?.save();
                        StockmanagerController.to.isClick.value = true;
                      }
                      sellingPriceCalculate(
                              StockmanagerController.to.costPrice.value,
                              StockmanagerController.to.earningRate.value,
                              StockmanagerController.to.commissionRate.value,
                              StockmanagerController.to.deliveryCharge.value)
                          .toString();
                      commissionCalaulate(
                          StockmanagerController.to.commissionRate.value);
                      earningCalaulate(
                          StockmanagerController.to.earningRate.value);
                    },
                    child: Text('판매가 계산'),
                  ),
                  SizedBox(height: 15),
                  if (StockmanagerController.to.isClick.value)
                    Column(
                      children: [
                        calculateResult(
                            '상품판매가',
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
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('닫기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
        SizedBox(width: 15),
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
