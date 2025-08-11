import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goods_firebase_model.dart';

// GoodsRepository를 제공하는 Provider
final goodsRepositoryProvider = Provider<GoodsRepository>((ref) {
  return GoodsRepository(FirebaseFirestore.instance);
});

class GoodsRepository {
  final FirebaseFirestore _firestore;

  GoodsRepository(this._firestore);

  // 모든 상품 목록을 Stream으로 가져오기
  Stream<List<GoodsFirebaseModel>> getGoodsStream() {
    return _firestore.collection('goodsData').snapshots().map((snapshot) {
          
          // --- 디버깅을 위한 로그 추가 ---
          debugPrint("✅ Firestore에서 ${snapshot.docs.length}개의 상품 데이터를 가져왔습니다.");
          // --------------------------

          return snapshot.docs
              .map((doc) => GoodsFirebaseModel.fromMap(doc.data()))
              .toList();
        });
  }

  // 특정 카테고리의 상품 목록을 Stream으로 가져오기
  Stream<List<GoodsFirebaseModel>> getGoodsStreamByCategory(String category) {
    return _firestore
        .collection('goodsData')
        .where('카테고리', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => GoodsFirebaseModel.fromMap(doc.data())).toList());
  }
  
  // 상품 추가/수정
  Future<void> saveGoods(GoodsFirebaseModel goods) async {
    await _firestore.collection('goodsData').doc(goods.itemNumber).set(goods.toMap());
  }

  // 상품 삭제 (필요 시)
  Future<void> deleteGoods(String itemNumber) async {
    await _firestore.collection('goodsData').doc(itemNumber).delete();
  }
}