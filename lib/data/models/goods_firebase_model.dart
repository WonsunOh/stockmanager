//기초상품들의 데이터베이스

class GoodsFirebaseModel {
  String? itemNumber;
  String? category;
  String? title;
  String? inputDay;
  String? number;
  String? price;
  String? weight;
  String? stock;
  String? memo;

  GoodsFirebaseModel({
    this.itemNumber,
    this.category,
    this.title,
    this.inputDay,
    this.number,
    this.price,
    this.weight,
    this.stock,
    this.memo,
  });
   // Firestore 데이터를 모델로 변환하는 부분을 더 안전하게 수정
  factory GoodsFirebaseModel.fromMap(Map<String, dynamic> json) {
    return GoodsFirebaseModel(
      // json['필드명'] ?? '기본값' 형태로 변경하여 null 에러를 방지합니다.
      itemNumber: json['아이템 넘버'] as String? ?? '',
      category: json['카테고리'] as String? ?? '기타',
      title: json['상품명'] as String? ?? '이름 없음',
      inputDay: json['입력일'] as String? ?? '',
      number: json['상품갯수'] as String? ?? '0',
      price: json['상품가격'] as String? ?? '0',
      weight: json['상품무게'] as String? ?? '0',
      stock: json['상품재고'] as String? ?? '0',
      memo: json['메모'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemNumber': itemNumber,
      'category': category,
      'title': title,
      'inputDay': inputDay,
      'number': number,
      'price': price,
      'weight': weight,
      'stock': stock,
      'memo': memo,
    };
  }

}
