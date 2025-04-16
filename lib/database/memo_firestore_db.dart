import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/memo_firebase_model.dart';

class MemoFirestoreDb {
  static addMemo(MemoFirebaseModel memoModel) async {
    var uuid = const Uuid().v4();
    await FirebaseFirestore.instance.collection('memoData').doc(uuid).set({
      'id': uuid,
      // 'id': FieldValue.increment(1),
      'writer': memoModel.writer,
      'title': memoModel.title,
      'inputDay': memoModel.inputDay,
      'completionDay': memoModel.completionDay,
      'completionRate': memoModel.completionRate,
      'category': memoModel.category,
      'content': memoModel.content,
    });
  }

  static Stream<List<MemoFirebaseModel>> MemoStream() {
    return FirebaseFirestore.instance
        .collection('memoData')
        .orderBy("inputDay", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MemoFirebaseModel> memoList = [];
      for (var element in query.docs) {
        memoList.add(MemoFirebaseModel.fromDocumentSnapshot(element));
      }
      return memoList;
    });
  }

  static updateMemo(MemoFirebaseModel memoModel) async {
    await FirebaseFirestore.instance
        .collection('memoData')
        .doc(memoModel.id)
        .update({
      'id': memoModel.id,
      'writer': memoModel.writer,
      'title': memoModel.title,
      'inputDay': memoModel.inputDay,
      'completionDay': memoModel.completionDay,
      'completionRate': memoModel.completionRate,
      'category': memoModel.category,
      'content': memoModel.content,
    });
  }

  static updatePiecesMemo(String fieldName, String data, String id) async {
    await FirebaseFirestore.instance.collection('memoData').doc(id).update({
      fieldName: data,
    });
  }
}
