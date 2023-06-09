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
  factory GoodsFirebaseModel.fromMap(Map<dynamic, dynamic> json) {
    return GoodsFirebaseModel(
      itemNumber: json['itemNumber'],
      category: json['category'],
      title: json['title'],
      inputDay: json['inputDay'],
      number: json['number'],
      price: json['price'],
      weight: json['weight'],
      stock: json['stock'],
      memo: json['memo'],
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
