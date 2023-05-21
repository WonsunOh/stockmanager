import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockmanagerController extends GetxController {
  static StockmanagerController get to => Get.find();

  final dropdownValue = '배송선택'.obs;
  final List<String> deliveryList = ['배송선택', '유료배송', '무료배송'];

  final isClick = false.obs;

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
        SizedBox(width: 10),
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
