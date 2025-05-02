import 'package:get/get.dart';
import 'package:stockmanager/database/goods_firestore_db.dart';
import '../database/product_firestore_db.dart';
import '../models/goods_firebase_model.dart';

import 'package:stockmanager/database/memo_firestore_db.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

import '../models/product_firebase_model.dart';



class DatabaseController extends GetxController {
  static DatabaseController get to => Get.find();

  // var goodsList = Rx<List<GoodsFirebaseModel>>([]).obs;

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


  //상품 DB
  addGoodsStock(GoodsFirebaseModel goodsStock) async {
    await GoodsFirestoreDb.addGoods(goodsStock);
  }

  addPicesGoodsStock(String? goodsStock, String itemStock, String item) async {
    await GoodsFirestoreDb.addPicesGoods(goodsStock!, itemStock, item);
  }

  updateGoodsStock(GoodsFirebaseModel goodsStock) async {
    await GoodsFirestoreDb.updateGoods(goodsStock);
  }

  updatePiecesGoodsStock(
      String? goodsStock, String itemStock, String item) async {
    await GoodsFirestoreDb.updatePiecesGoods(goodsStock!, itemStock, item);
  }

  //제품 DB
  addProductStock(ProductFirebaseModel ProductStock) async {
    await ProductFirestoreDb.addProduct(ProductStock);
  }

  addPicesProductStock(String? productStock, String itemStock, String item) async {
    await ProductFirestoreDb.addPicesProduct(productStock!, itemStock, item);
  }

  updateProductStock(ProductFirebaseModel productStock) async {
    await ProductFirestoreDb.updateProduct(productStock);
  }

  updatePiecesProductStock(
      String? productStock, String itemStock, String item) async {
    await ProductFirestoreDb.updatePiecesProduct(productStock!, itemStock, item);
  }

  //메모 DB
  addMemo(MemoFirebaseModel memo) async {
    await MemoFirestoreDb.addMemo(memo);
  }

  updateMemo(MemoFirebaseModel memo) async {
    await MemoFirestoreDb.updateMemo(memo);
  }

  updatePiecesMemo(String memoItem, String item, String? id) async {
    await MemoFirestoreDb.updatePiecesMemo(memoItem, item, id!);
  }
}
