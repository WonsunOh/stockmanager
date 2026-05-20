/// Supabase `products` table model.
///
/// Replaces the legacy `ProductFirebaseModel` (Firestore `productData`).
/// Field names follow Supabase column names; mapping is done in fromMap/toMap.
///
/// The `products` table is shared with another shop-catalog system.
/// Columns the Flutter app does not edit (description, tags, shipping_fee,
/// discount_*, additional_images, source_url, external_product_id) are
/// preserved in fromMap so reads round-trip safely but are not exposed via
/// toMap unless explicitly set.
class ProductModel {
  final int? id;
  final String? name;
  final String? productCode;
  final String? relatedProductCode;
  final int? categoryId;
  final String? firebaseCategory;
  final int? totalPrice;
  final int? unitPrice;
  final int? costPrice;
  final int? stockQuantity;
  final int? quantity;
  final String? weight;
  final num? commissionRate;
  final num? earningRate;
  final num? commission;
  final num? earning;
  final String? deliveryMethod;
  final String? memo;
  final String? imageUrl;
  final List<String>? additionalImages;
  final bool? isDisplayed;
  final bool? isSoldOut;
  final DateTime? createdAt;

  const ProductModel({
    this.id,
    this.name,
    this.productCode,
    this.relatedProductCode,
    this.categoryId,
    this.firebaseCategory,
    this.totalPrice,
    this.unitPrice,
    this.costPrice,
    this.stockQuantity,
    this.quantity,
    this.weight,
    this.commissionRate,
    this.earningRate,
    this.commission,
    this.earning,
    this.deliveryMethod,
    this.memo,
    this.imageUrl,
    this.additionalImages,
    this.isDisplayed,
    this.isSoldOut,
    this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String?,
      productCode: map['product_code'] as String?,
      relatedProductCode: map['related_product_code'] as String?,
      categoryId: map['category_id'] as int?,
      firebaseCategory: map['firebase_category'] as String?,
      totalPrice: (map['total_price'] as num?)?.toInt(),
      unitPrice: (map['unit_price'] as num?)?.toInt(),
      costPrice: (map['cost_price'] as num?)?.toInt(),
      stockQuantity: (map['stock_quantity'] as num?)?.toInt(),
      quantity: (map['quantity'] as num?)?.toInt(),
      weight: map['weight']?.toString(),
      commissionRate: map['commission_rate'] as num?,
      earningRate: map['earning_rate'] as num?,
      commission: map['commission'] as num?,
      earning: map['earning'] as num?,
      deliveryMethod: map['delivery_method'] as String?,
      memo: map['memo'] as String?,
      imageUrl: map['image_url'] as String?,
      additionalImages: (map['additional_images'] as List?)?.cast<String>(),
      isDisplayed: map['is_displayed'] as bool?,
      isSoldOut: map['is_sold_out'] as bool?,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'] as String),
    );
  }

  /// Map for insert/update. Only includes Flutter-app-managed columns.
  /// Untouched columns (description, tags, shipping_fee, discount_*, ...)
  /// keep their existing values on update.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'product_code': productCode,
      'related_product_code': relatedProductCode,
      'category_id': categoryId,
      'firebase_category': firebaseCategory,
      'total_price': totalPrice,
      'unit_price': unitPrice,
      'cost_price': costPrice,
      'stock_quantity': stockQuantity,
      'quantity': quantity,
      'weight': weight,
      'commission_rate': commissionRate,
      'earning_rate': earningRate,
      'commission': commission,
      'earning': earning,
      'delivery_method': deliveryMethod,
      'memo': memo,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? productCode,
    String? relatedProductCode,
    int? categoryId,
    String? firebaseCategory,
    int? totalPrice,
    int? unitPrice,
    int? costPrice,
    int? stockQuantity,
    int? quantity,
    String? weight,
    num? commissionRate,
    num? earningRate,
    num? commission,
    num? earning,
    String? deliveryMethod,
    String? memo,
    String? imageUrl,
    List<String>? additionalImages,
    bool? isDisplayed,
    bool? isSoldOut,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      productCode: productCode ?? this.productCode,
      relatedProductCode: relatedProductCode ?? this.relatedProductCode,
      categoryId: categoryId ?? this.categoryId,
      firebaseCategory: firebaseCategory ?? this.firebaseCategory,
      totalPrice: totalPrice ?? this.totalPrice,
      unitPrice: unitPrice ?? this.unitPrice,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      commissionRate: commissionRate ?? this.commissionRate,
      earningRate: earningRate ?? this.earningRate,
      commission: commission ?? this.commission,
      earning: earning ?? this.earning,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      memo: memo ?? this.memo,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      isDisplayed: isDisplayed ?? this.isDisplayed,
      isSoldOut: isSoldOut ?? this.isSoldOut,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
