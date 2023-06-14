import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockmanager/models/goods_firebase_model.dart';

class FirestoreDb {
  static addGoods(GoodsFirebaseModel goodsmodel) async {
    await FirebaseFirestore.instance
        .collection('goodsData')
        .doc('${goodsmodel.itemNumber}')
        .set({
      '카테고리': goodsmodel.category,
      '아이템 넘버': goodsmodel.itemNumber,
      '상품명': goodsmodel.title,
      '상품갯수': goodsmodel.number,
      '상품가격': goodsmodel.price,
      '상품무게': goodsmodel.weight,
      '상품재고': goodsmodel.stock,
      '메모': goodsmodel.memo,
    });
  }

  // static Stream<List<GoodsFirebaseModel>> goodsStream(){
  //   return FirebaseFirestore.instance
  //       .collection('goodsData')
  //       .doc('goods')
  //       .collection('${GoodsFirebaseModel.itemNumber}').snapshots().map((QuerySnapshot query){
  //         List<GoodsFirebaseModel> goodsList = [];
  //         for (var good in query.docs) {
  //           final goodsModel = GoodsFirebaseModel.fromMap(good);
  //           goodsList.add(goodsModel);
  //         }
  //   })
  // }

  static addPicesGoods(
      String itmNumber, String fieldName, String data) async {
    await FirebaseFirestore.instance
        .collection('goodsData')
        .doc('${itmNumber}')
        .set({
      fieldName: data,
    });
  }



  static updateGoods(GoodsFirebaseModel goodsmodel) async {
    await FirebaseFirestore.instance
        .collection('goodsData')
        .doc('${goodsmodel.itemNumber}')
        .update({
      '카테고리': goodsmodel.category,
      '아이템 넘버': goodsmodel.itemNumber,
      '상품명': goodsmodel.title,
      '상품갯수': goodsmodel.number,
      '상품가격': goodsmodel.price,
      '상품무게': goodsmodel.weight,
      '상품재고': goodsmodel.stock,
      '메모': goodsmodel.memo,
    });
  }

  static updatePicesGoods(
      String itmNumber, String fieldName, String data) async {
    await FirebaseFirestore.instance
        .collection('goodsData')
        .doc('${itmNumber}')
        .update({
      fieldName: data,
    });
  }
}
