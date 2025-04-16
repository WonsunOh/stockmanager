import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockmanagerController extends GetxController {
  static StockmanagerController get to => Get.find();


  //good_list.dart
  final currentGoodsClassify = '모든카테고리'.obs;
  final List<String> goodsTypeToString = [
    '모든카테고리',
    '과자',
    '사탕',
    '젤리',
    '초콜릿',
    '껌',
    '차,음료',
    '기타',
  ];
  void setListSelected(String value) {
    currentGoodsClassify.value = value;
  }


  //good_price_calculator.dart add_product_form.dart
  final dropdownValue = '배송선택'.obs;
  final List<String> deliveryList = ['배송선택', '유료배송', '무료배송'];

  final categroyValue = '선택'.obs;
  final List<String> productCategroy = ['선택',
    '과자',
    '사탕',
    '젤리',
    '초콜릿',
    '껌',
    '차,음료',
    '기타',];
  void setCategorySelected(String value) {
    categroyValue.value = value;
  }

  final isClick = false.obs;

  final productName = ''.obs;
  final itemNumber = ''.obs;
  final itemCost = ''.obs;

  final productCost = ''.obs;

  final costPrice = ''.obs;
  final commissionRate = ''.obs;
  final earningRate = ''.obs;
  final sellingPrice = ''.obs;
  final deliveryCharge = ''.obs;

  final commission = ''.obs;
  final earning = ''.obs;



  void setSelected(String value) {
    dropdownValue.value = value;
  }



  Widget input_text(String title, String formValue) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: 60,
          child: Text(title),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: TextFormField(
          onChanged: (val) {
            formValue = val;
          },
          validator: (val) {
            return null;
          },
        )),
      ],
    );
  }
}
