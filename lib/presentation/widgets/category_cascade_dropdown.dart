import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';

/// 3-level cascading dropdown for [CategoryTree].
///
/// Emits the **deepest selected** category id via [onChanged]. Selecting a
/// shallower level resets all deeper levels. A value of `null` means nothing
/// selected at that level.
///
/// Optional [allowAllAtRoot] adds a "전체" sentinel at level 1 — useful for
/// filter UIs. When that sentinel is picked, [onChanged] receives `null`.
class CategoryCascadeDropdown extends ConsumerStatefulWidget {
  final int? initialCategoryId;
  final ValueChanged<int?> onChanged;
  final bool allowAllAtRoot;
  final String? validatorMessage; // when non-null and value is null → error
  final String allLabel;

  const CategoryCascadeDropdown({
    super.key,
    required this.onChanged,
    this.initialCategoryId,
    this.allowAllAtRoot = false,
    this.validatorMessage,
    this.allLabel = '전체',
  });

  @override
  ConsumerState<CategoryCascadeDropdown> createState() =>
      _CategoryCascadeDropdownState();
}

class _CategoryCascadeDropdownState
    extends ConsumerState<CategoryCascadeDropdown> {
  int? _l1Id;
  int? _l2Id;
  int? _l3Id;
  bool _initialised = false;

  @override
  Widget build(BuildContext context) {
    final treeAsync = ref.watch(categoryTreeProvider);
    return treeAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      ),
      error: (e, st) => Text('카테고리 로딩 실패: $e',
          style: const TextStyle(color: Colors.red)),
      data: (tree) {
        if (!_initialised) {
          _seedFromId(tree, widget.initialCategoryId);
          _initialised = true;
        }
        return _buildDropdowns(tree);
      },
    );
  }

  void _seedFromId(CategoryTree tree, int? id) {
    final path = tree.pathTo(id);
    _l1Id = path.isNotEmpty ? path[0].id : null;
    _l2Id = path.length >= 2 ? path[1].id : null;
    _l3Id = path.length >= 3 ? path[2].id : null;
  }

  int? _currentSelectionId() => _l3Id ?? _l2Id ?? _l1Id;

  void _emit() => widget.onChanged(_currentSelectionId());

  Widget _buildDropdowns(CategoryTree tree) {
    final level1 = tree.children(null);
    final level2 = _l1Id == null ? <CategoryModel>[] : tree.children(_l1Id);
    final level3 = _l2Id == null ? <CategoryModel>[] : tree.children(_l2Id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dropdown(
          label: '대분류',
          value: _l1Id,
          items: level1,
          showAll: widget.allowAllAtRoot,
          onChanged: (v) {
            setState(() {
              _l1Id = v;
              _l2Id = null;
              _l3Id = null;
            });
            _emit();
          },
        ),
        if (level2.isNotEmpty) const SizedBox(height: 8),
        if (level2.isNotEmpty)
          _dropdown(
            label: '중분류',
            value: _l2Id,
            items: level2,
            showAll: false,
            onChanged: (v) {
              setState(() {
                _l2Id = v;
                _l3Id = null;
              });
              _emit();
            },
          ),
        if (level3.isNotEmpty) const SizedBox(height: 8),
        if (level3.isNotEmpty)
          _dropdown(
            label: '소분류',
            value: _l3Id,
            items: level3,
            showAll: false,
            onChanged: (v) {
              setState(() => _l3Id = v);
              _emit();
            },
          ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required int? value,
    required List<CategoryModel> items,
    required bool showAll,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int?>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        if (showAll)
          DropdownMenuItem<int?>(value: null, child: Text(widget.allLabel)),
        ...items.map(
          (c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name)),
        ),
      ],
      onChanged: onChanged,
      validator: widget.validatorMessage == null
          ? null
          : (v) => v == null ? widget.validatorMessage : null,
    );
  }
}
