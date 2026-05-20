/// Supabase `categories` table model. Self-referential tree via `parent_id`.
class CategoryModel {
  final int id;
  final String name;
  final int? parentId;

  const CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      name: (map['name'] as String?) ?? '',
      parentId: map['parent_id'] as int?,
    );
  }
}

/// Read-only tree built once per fetch. Provides path lookup utilities.
class CategoryTree {
  final List<CategoryModel> all;
  final Map<int, CategoryModel> byId;
  final Map<int, List<CategoryModel>> childrenOf;
  final List<CategoryModel> roots;

  CategoryTree._(this.all, this.byId, this.childrenOf, this.roots);

  factory CategoryTree.fromList(List<CategoryModel> rows) {
    final byId = <int, CategoryModel>{for (final c in rows) c.id: c};
    final children = <int, List<CategoryModel>>{};
    final roots = <CategoryModel>[];
    for (final c in rows) {
      if (c.parentId == null) {
        roots.add(c);
      } else {
        children.putIfAbsent(c.parentId!, () => []).add(c);
      }
    }
    int byName(CategoryModel a, CategoryModel b) => a.name.compareTo(b.name);
    roots.sort(byName);
    for (final list in children.values) {
      list.sort(byName);
    }
    return CategoryTree._(rows, byId, children, roots);
  }

  List<CategoryModel> children(int? parentId) {
    if (parentId == null) return roots;
    return childrenOf[parentId] ?? const [];
  }

  /// Ancestors from root to the node itself. Empty if id not found.
  List<CategoryModel> pathTo(int? id) {
    if (id == null) return const [];
    final chain = <CategoryModel>[];
    var node = byId[id];
    while (node != null) {
      chain.insert(0, node);
      node = node.parentId == null ? null : byId[node.parentId!];
    }
    return chain;
  }

  /// "식품 > 과자/간식 > 과자" string, or empty.
  String pathString(int? id, {String separator = ' > '}) {
    final p = pathTo(id);
    if (p.isEmpty) return '';
    return p.map((c) => c.name).join(separator);
  }

  /// All descendant ids INCLUDING the node itself. Use for "category and its
  /// children" filters.
  Set<int> descendantIdsInclusive(int id) {
    final result = <int>{id};
    final queue = <int>[id];
    while (queue.isNotEmpty) {
      final next = queue.removeLast();
      for (final c in children(next)) {
        if (result.add(c.id)) queue.add(c.id);
      }
    }
    return result;
  }
}
