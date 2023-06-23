import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/memo_firebase_model.dart';

class MemoFirestoreDb {
  static addMemo(MemoFirebaseModel memo_model) async {
    final docIcrement = FirebaseFirestore.instance.collection('memoData').doc();
    await FirebaseFirestore.instance.collection('memoData').doc().set({
      'id': docIcrement.id,
      // 'id': FieldValue.increment(1),
      'writer': memo_model.writer,
      'title': memo_model.title,
      'inputDay': memo_model.inputDay,
      'completionDay': memo_model.completionDay,
      'completionRate': memo_model.completionRate,
      'category': memo_model.category,
      'content': memo_model.content,
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

  static updateMemo(MemoFirebaseModel memo_model) async {
    await FirebaseFirestore.instance.collection('memoData').doc().update({
      'id': memo_model.id,
      'writer': memo_model.writer,
      'title': memo_model.title,
      'inputDay': memo_model.inputDay,
      'completionDay': memo_model.completionDay,
      'completionRate': memo_model.completionRate,
      'category': memo_model.category,
      'content': memo_model.content,
    });
  }

  static updatePiecesMemo(
      String fieldName, String data, String doc) async {
    await FirebaseFirestore.instance
        .collection('goodsData')
        .doc('${doc}')
        .update({
      fieldName: data,
    });
  }
}
