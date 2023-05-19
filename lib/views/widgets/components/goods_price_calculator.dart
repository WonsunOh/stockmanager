import 'dart:js';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/stockmanager_controller.dart';

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
  String costPrice = '';
  String commissionRate = '';
  String earningRate = '';
  String sellingPrice = '';
  String deliveryCharge = '';
  @override
  GoodsPriceCalculator() {
    Get.dialog(
      AlertDialog(
        title: Text('상품 판매가 계산기 V1.0'),
        content: Form(
          key: _formkey,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                input_text('원가',costPrice),
                input_text('수수료율', commissionRate),
                input_text('수익률', earningRate),
                Row(
                  children: [
                    Text('배송방법'),
                    SizedBox(width: 15),
                    Obx(
                      () => DropdownButton<String>(
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
                    ),
                  ],
                ),
                //무료배송이면 배송비 입력란이 나오게
                // StockmanagerController.to.dropdownValue == '무료배송' ? input_text('배송비') : Container(),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: (){

                  },
                  child: Text('판매가 계산'),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text('상품 판매가'),
                    SizedBox(width: 15
                    ),
                    Text('')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget input_text(String title, String formValue) {
    return Row(
      children: [
        Text(title),
        SizedBox(width: 15),
        Expanded(
            child: TextFormField(
          onChanged: (val) {
            formValue = val;
          },
        )),
      ],
    );
  }

  sellingPriceCalculate(){
    if(StockmanagerController.to.dropdownValue.value == '유료배송') {
      sellingPrice = ((((int.parse(costPrice) / (1 - int.parse(earningRate) - int.parse(commissionRate))) /10).round())*10).toString();
  } else if(StockmanagerController.to.dropdownValue.value == '무료배송') {
      sellingPrice = (((((int.parse(costPrice)+int.parse(deliveryCharge)) / (1 - int.parse(earningRate) - int.parse(commissionRate))) /10).round())*10).toString();
    }

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
