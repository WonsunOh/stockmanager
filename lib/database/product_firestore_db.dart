import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockmanager/models/goods_firebase_model.dart';

import '../models/product_firebase_model.dart';

class ProductFirestoreDb {
  static addProduct(ProductFirebaseModel productmodel) async {
    await FirebaseFirestore.instance
        .collection('productData')
        .doc('${productmodel.itemNumber}')
        .set({
      '카테고리': productmodel.category,
      '제품코드': productmodel.itemNumber,
      '연관상품코드': productmodel.g_itemNumber,
      '제품명': productmodel.title,
      '원료상품명': productmodel.g_title,
      '입력일': productmodel.inputDay,
      '원료갯수': productmodel.number,
      '개당원가': productmodel.p_price,
      '제품무게': productmodel.weight,
      '수수료율': productmodel.commissionRate,
      '수익률': productmodel.earningRate,
      '배송방법': productmodel.deliveryMethod,
      '제품재고량': productmodel.stock,
      '메모': productmodel.memo,

      '제품원가': productmodel.costPrice,
      '판매가': productmodel.price,
      '수수료': productmodel.commission,
      '수익': productmodel.earning,
    });
  }



  static addPicesProduct(
      String itmNumber, String fieldName, String data) async {
    await FirebaseFirestore.instance
        .collection('productData')
        .doc(itmNumber)
        .set({
      fieldName: data,
    });
  }



  static updateProduct(ProductFirebaseModel productmodel) async {
    await FirebaseFirestore.instance
        .collection('productData')
        .doc('${productmodel.itemNumber}')
        .update({
      '카테고리': productmodel.category,
      '제품코드': productmodel.itemNumber,
      '연관상품코드': productmodel.g_itemNumber,
      '제품명': productmodel.title,
      '원료상품명': productmodel.g_title,
      '입력일': productmodel.inputDay,
      '원료갯수': productmodel.number,
      '개당원가': productmodel.p_price,
      '제품무게': productmodel.weight,
      '수수료율': productmodel.commissionRate,
      '수익률': productmodel.earningRate,
      '배송방법': productmodel.deliveryMethod,
      '제품재고량': productmodel.stock,
      '메모': productmodel.memo,

      '제품원가': productmodel.costPrice,
      '판매가': productmodel.price,
      '수수료': productmodel.commission,
      '수익': productmodel.earning,
    });
  }

  static updatePiecesProduct(
      String itmNumber, String fieldName, String data) async {
    await FirebaseFirestore.instance
        .collection('productData')
        .doc(itmNumber)
        .update({
      fieldName: data,
    });
  }
}
