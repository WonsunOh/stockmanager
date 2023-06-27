import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/memo_firebase_model.dart';

class MemoFirestoreDb {
  static addMemo(MemoFirebaseModel memo_model) async {
    var uuid = Uuid().v4();
    await FirebaseFirestore.instance.collection('memoData').doc(uuid).set({
      'id': uuid,
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

  static Stream<List<MemoFirebaseModel>> MemoStream() {
    return FirebaseFirestore.instance
        .collection('memoData')
        .orderBy("inputDay", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MemoFirebaseModel> memoList = [];
      query.docs.forEach((element) {
        memoList.add(MemoFirebaseModel.fromDocumentSnapshot(element));
      });
      return memoList;
    });
  }

  static updateMemo(MemoFirebaseModel memo_model) async {
    await FirebaseFirestore.instance
        .collection('memoData')
        .doc(memo_model.id)
        .update({
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

  static updatePiecesMemo(String fieldName, String data, String id) async {
    await FirebaseFirestore.instance.collection('memoData').doc(id).update({
      fieldName: data,
    });
  }
}
