import 'package:get/get.dart';

class StockmanagerController extends GetxController {
  static StockmanagerController get to => Get.find();

  final dropdownValue = '배송선택'.obs;
  final List<String> deliveryList = ['배송선택', '유료배송', '무료배송'];

  void setSelected(String value) {
    dropdownValue.value = value;
  }
}
