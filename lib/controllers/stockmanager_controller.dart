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
  void setSelected(String value) {
    dropdownValue.value = value;
  }


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


  final unitSelectValue = 'g'.obs;
  final List<String> goodsUint = ['g', 'ml'];
  void setUintSelected(String value) {
    unitSelectValue.value = value;
  }



  final isClick = false.obs;
  final isClickCode = false.obs;

  final g_itemNumber = ''.obs; //연관상품코드
  final g_name = ''.obs; //구성 상품명
  final g_category = ''.obs; //구성 카테고리
  final itemCost = ''.obs;  //개당 원가
  final itemWeight = ''.obs; //개당 무게


  //제품관련 변수
  final number = ''.obs;  // 제품갯수
  final productName = ''.obs; //제품명
  final category = ''.obs;  //제품 카테고리 = g_category
  final productNumber = ''.obs; // 제품코드
  final productCost = ''.obs;  //제품 원가
  final productWeight = ''.obs; //제품 무게

  final commissionRate = ''.obs; //수수료율
  final earningRate = ''.obs;  //수익률
  final sellingPrice = ''.obs;  //제품 판매가
  final deliveryCharge = ''.obs; //배송비

  final commission = ''.obs; //제품 판매수수료
  final earning = ''.obs;  //제품 판매수익


  final costPrice = ''.obs;





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
