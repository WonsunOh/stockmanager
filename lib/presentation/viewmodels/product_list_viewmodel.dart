import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/repositories/product_repository.dart';

import '../../data/models/product_model.dart';

// 1. Provider를 StreamNotifierProvider로 변경
final productListViewModelProvider =
    StreamNotifierProvider.autoDispose<ProductListViewModel, List<ProductFirebaseModel>>(
  ProductListViewModel.new,
);

// 2. Notifier를 AutoDisposeStreamNotifier로 변경
class ProductListViewModel extends AutoDisposeStreamNotifier<List<ProductFirebaseModel>> {
  @override
  Stream<List<ProductFirebaseModel>> build() {
    final productRepository = ref.watch(productRepositoryProvider);
    return productRepository.getProductsStream();
  }
}