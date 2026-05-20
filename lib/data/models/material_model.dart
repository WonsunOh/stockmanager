/// Supabase `materials` table model.
///
/// Replaces the legacy `GoodsFirebaseModel` (Firestore `goodsData`).
/// Field names follow Supabase column names; mapping is done in fromMap/toMap.
class MaterialModel {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? firebaseCategory;
  final int? price;
  final int? unitPrice;
  final int? stockQuantity;
  final String? unit;
  final String? weight;
  final int? quantity;
  final String? memo;
  final String? imageUrl;
  final String? originalItemNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MaterialModel({
    this.id,
    this.name,
    this.categoryId,
    this.firebaseCategory,
    this.price,
    this.unitPrice,
    this.stockQuantity,
    this.unit,
    this.weight,
    this.quantity,
    this.memo,
    this.imageUrl,
    this.originalItemNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      id: map['id'] as int?,
      name: map['name'] as String?,
      categoryId: map['category_id'] as int?,
      firebaseCategory: map['firebase_category'] as String?,
      price: (map['price'] as num?)?.toInt(),
      unitPrice: (map['unit_price'] as num?)?.toInt(),
      stockQuantity: (map['stock_quantity'] as num?)?.toInt(),
      unit: map['unit'] as String?,
      weight: map['weight']?.toString(),
      quantity: (map['quantity'] as num?)?.toInt(),
      memo: map['memo'] as String?,
      imageUrl: map['image_url'] as String?,
      originalItemNumber: map['original_item_number'] as String?,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(map['updated_at'] as String),
    );
  }

  /// Map for insert/update. `id`, `created_at`, `updated_at` are managed by DB.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'category_id': categoryId,
      'firebase_category': firebaseCategory,
      'price': price,
      'unit_price': unitPrice,
      'stock_quantity': stockQuantity,
      'unit': unit,
      'weight': weight,
      'quantity': quantity,
      'memo': memo,
      'image_url': imageUrl,
      'original_item_number': originalItemNumber,
    };
  }

  MaterialModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? firebaseCategory,
    int? price,
    int? unitPrice,
    int? stockQuantity,
    String? unit,
    String? weight,
    int? quantity,
    String? memo,
    String? imageUrl,
    String? originalItemNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      firebaseCategory: firebaseCategory ?? this.firebaseCategory,
      price: price ?? this.price,
      unitPrice: unitPrice ?? this.unitPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      memo: memo ?? this.memo,
      imageUrl: imageUrl ?? this.imageUrl,
      originalItemNumber: originalItemNumber ?? this.originalItemNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
