import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/controllers/stockmanager_controller.dart';

import 'controllers/database_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<DatabaseController>(DatabaseController());
    Get.put<StockmanagerController>(StockmanagerController());
    Get.put<MemoController>(MemoController());
  }
}
