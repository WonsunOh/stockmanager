//제품들의 데이터베이스
// 연관상품코드도 추가해야 할 듯.

class ProductFirebaseModel {
  String? g_itemNumber; // 연관 상품 코드
  String? itemNumber;  //코드
  String? category;
  String? title;
  String? g_title; //구성 상품명
  String? inputDay;
  String? number; //원료갯수
  String? p_price; //개당 원가
  String? weight; //제품 무게
  String? commissionRate; //수수료율
  String? earningRate; //수익률
  String? deliveryMethod; //배송방법
  String? stock; //재고량
  String? memo;

  String? costPrice; //원가
  String? price; //판매가
  String? commission; //수수료
  String? earning; //판매수익

  ProductFirebaseModel({
    this.g_itemNumber,
    this.itemNumber,
    this.category,
    this.title,
    this.g_title,
    this.inputDay,
    this.number,
    this.p_price,
    this.weight,
    this.commissionRate,
    this.earningRate,
    this.deliveryMethod,
    this.stock,
    this.memo,
    this.costPrice,
    this.price,
    this.commission,
    this.earning,
  });
  factory ProductFirebaseModel.fromMap(Map<dynamic, dynamic> json) {
    return ProductFirebaseModel(
      g_itemNumber: json['g_itemNumber'],
      itemNumber: json['itemNumber'],
      category: json['category'],
      title: json['title'],
      g_title: json['g_title'],
      inputDay: json['inputDay'],
      number: json['number'],
      p_price: json['p_price'],
      weight: json['weight'],
      commissionRate: json['commissionRate'],
      earningRate: json['earningRate'],
      deliveryMethod: json['deliveryMethod'],
      stock: json['stock'],
      memo: json['memo'],
      costPrice: json['costPrice'],
      price: json['price'],
      commission: json['commission'],
      earning:json['earning'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'g_itemNumber': g_itemNumber,
      'itemNumber': itemNumber,
      'category': category,
      'title': title,
      'g_title': g_title,
      'inputDay': inputDay,
      'number': number,
      'p_price': p_price,
      'weight': weight,
      'commissionRate': commissionRate,
      'earningRate': earningRate,
      'deliveryMethod': deliveryMethod,
      'stock': stock,
      'memo': memo,
      'costPrice': costPrice,
      'price': price,
      'commission': commission,
      'earning': earning,
    };
  }

  exchange(String itemStock) {
    String? item;
    item = itemStock;
    return item;
  }
}
