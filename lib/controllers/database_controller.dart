import 'package:get/get.dart';
import 'package:stockmanager/database/firestore_db.dart';

import '../models/goods_firebase_model.dart';

class DatabaseController extends GetxController {
  static DatabaseController get to => Get.find();

  var goodsList = Rx<List<GoodsFirebaseModel>>([]).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // goodsList.bindStream(stream)
    // TODO: implement onReady
    super.onReady();
  }

  addGoodsStock(GoodsFirebaseModel goodsStock) async {
    await FirestoreDb.addGoods(goodsStock);
  }

  updateGoodsStock(GoodsFirebaseModel goodsStock) async {
    await FirestoreDb.updateGoods(goodsStock);
  }

  updatePicesGoodsStock(
      String? goodsStock, String itemStock, String item) async {
    await FirestoreDb.updatePices(goodsStock!, itemStock, item);
  }
}
