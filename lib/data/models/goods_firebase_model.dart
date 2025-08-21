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
  List<String>? imageUrls; // 1. 여러 이미지 URL을 저장할 리스트 필드 추가

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
    this.imageUrls, // 2. 생성자에 추가
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
      // 3. Firestore의 'imageUrls' 필드를 List<String>으로 변환
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : [],
    );
  }

  // Dart 객체를 Firestore 데이터로 변환할 때 호출됨
  Map<String, dynamic> toMap() {
    return {
      // 여기도 동일하게 한글 필드명으로 수정합니다.
      '아이템 넘버': itemNumber,
      '카테고리': category,
      '상품명': title,
      '입력일': inputDay,
      '상품갯수': number,
      '상품가격': price,
      '상품무게': weight,
      '상품재고': stock,
      '메모': memo,
      'imageUrls': imageUrls,
    };
  }

}
