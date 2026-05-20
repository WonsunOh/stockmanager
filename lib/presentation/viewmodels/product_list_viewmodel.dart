import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

final productListViewModelProvider =
    StreamNotifierProvider.autoDispose<ProductListViewModel, List<ProductModel>>(
  ProductListViewModel.new,
);

class ProductListViewModel extends AutoDisposeStreamNotifier<List<ProductModel>> {
  @override
  Stream<List<ProductModel>> build() {
    return ref.watch(productRepositoryProvider).getProductsStream();
  }
}
