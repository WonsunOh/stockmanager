import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/repositories/memo_repository.dart';

import '../../data/models/memo_model.dart';

// 1. Provider를 StreamNotifierProvider로 변경
final memoListViewModelProvider =
    StreamNotifierProvider.autoDispose<MemoListViewModel, List<MemoFirebaseModel>>(
  MemoListViewModel.new,
);

// 2. Notifier를 AutoDisposeStreamNotifier로 변경
class MemoListViewModel extends AutoDisposeStreamNotifier<List<MemoFirebaseModel>> {
  @override
  Stream<List<MemoFirebaseModel>> build() {
    final memoRepository = ref.watch(memoRepositoryProvider);
    // 이제 build 메서드가 Stream을 반환하는 것이 올바른 오버라이드가 됩니다.
    return memoRepository.getMemosStream();
  }

}