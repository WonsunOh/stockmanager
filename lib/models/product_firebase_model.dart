class ProductFirebaseModel {
  String? itemNumber;
  String? category;
  String? title;
  String? number; //원료갯수
  String? price; //판매가
  String? weight;
  String? stock;
  String? memo;

  ProductFirebaseModel({
    this.itemNumber,
    this.category,
    this.title,
    this.number,
    this.price,
    this.weight,
    this.stock,
    this.memo,
  });
  factory ProductFirebaseModel.fromMap(Map<dynamic, dynamic> json) {
    return ProductFirebaseModel(
      itemNumber: json['itemNumber'],
      category: json['category'],
      title: json['title'],
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
      'number': number,
      'price': price,
      'weight': weight,
      'stock': stock,
      'memo': memo,
    };
  }

  exchange(String itemStock) {
    String? item;
    item = itemStock;
    return item;
  }
}
