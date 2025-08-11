import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockmanager/data/repositories/memo_repository.dart';

import '../../data/models/memo_model.dart';

final addMemoViewModelProvider =
    StateNotifierProvider.autoDispose<AddMemoViewModel, AsyncValue<void>>(
  (ref) => AddMemoViewModel(ref.watch(memoRepositoryProvider)),
);

class AddMemoViewModel extends StateNotifier<AsyncValue<void>> {
  final MemoRepository _repository;

  AddMemoViewModel(this._repository) : super(const AsyncValue.data(null));

  Future<bool> saveMemo({
    MemoFirebaseModel? existingMemo,
    required String title,
    required String writer,
    required String category,
    required String content,
    required String completionRate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now().toString();
      
      final memo = MemoFirebaseModel(
        id: existingMemo?.id,
        title: title,
        writer: writer,
        category: category,
        content: content,
        completionRate: completionRate,
        inputDay: existingMemo?.inputDay ?? now, // 기존 메모가 있으면 날짜 유지, 없으면 새로 생성
        completionDay: completionRate == '100' ? now : (existingMemo?.completionDay ?? ''),
      );
      if (existingMemo == null) {
        await _repository.addMemo(memo);
      } else {
        await _repository.updateMemo(memo);
      }
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}