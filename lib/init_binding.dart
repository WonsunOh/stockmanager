import 'package:get/get.dart';

import 'controllers/database_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<DatabaseController>(DatabaseController());
  }
}
