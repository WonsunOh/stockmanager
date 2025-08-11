import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/memo_model.dart';

// 1. 이 Repository를 제공(provide)할 Provider를 전역으로 선언합니다.
final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  return MemoRepository(FirebaseFirestore.instance);
});

class MemoRepository {
  final FirebaseFirestore _firestore;

  MemoRepository(this._firestore);

  // 메모 목록을 Stream으로 가져오기
  Stream<List<MemoFirebaseModel>> getMemosStream() {
    return _firestore
        .collection('memoData')
        .orderBy("inputDay", descending: true)
        .snapshots()
        .map((query) {
      List<MemoFirebaseModel> memoList = [];
      for (var doc in query.docs) {
        memoList.add(MemoFirebaseModel.fromDocumentSnapshot(doc));
      }
      return memoList;
    });
  }

  // 메모 추가하기
  Future<void> addMemo(MemoFirebaseModel memoModel) async {
    final uuid = const Uuid().v4();
    await _firestore.collection('memoData').doc(uuid).set({
      'id': uuid,
      'writer': memoModel.writer,
      'title': memoModel.title,
      'inputDay': memoModel.inputDay,
      'completionDay': memoModel.completionDay,
      'completionRate': memoModel.completionRate,
      'category': memoModel.category,
      'content': memoModel.content,
    });
  }

  // 메모 수정하기
  Future<void> updateMemo(MemoFirebaseModel memoModel) async {
    await _firestore
        .collection('memoData')
        .doc(memoModel.id)
        .update(memoModel.toMap());
  }

  // (Optional) 메모 삭제하기
  Future<void> deleteMemo(String id) async {
    await _firestore.collection('memoData').doc(id).delete();
  }
}