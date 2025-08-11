import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

// Provider 생성
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(FirebaseFirestore.instance);
});

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository(this._firestore);

  // 제품 목록 Stream 가져오기
  Stream<List<ProductFirebaseModel>> getProductsStream() {
    return _firestore.collection('productData').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ProductFirebaseModel.fromMap(doc.data())).toList());
  }
  
  // 제품 추가/수정
  Future<void> saveProduct(ProductFirebaseModel product) async {
    // 제품 코드가 null이 아닌지 확인
    if (product.itemNumber == null || product.itemNumber!.isEmpty) {
      throw Exception("제품 코드는 비어 있을 수 없습니다.");
    }
    await _firestore.collection('productData').doc(product.itemNumber).set(product.toMap());
  }

  // 제품 삭제 (필요 시)
  Future<void> deleteProduct(String itemNumber) async {
    await _firestore.collection('productData').doc(itemNumber).delete();
  }
}