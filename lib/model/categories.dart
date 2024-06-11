const tableCategories = 'categories';

enum CategoriesType {
  expense(0),
  income(1),
  savings(2);

  const CategoriesType(this.value);
  final int value;
}

class CategoryFields {
  static final List<String> values = [
    id,
    title,
    iconCodePoint,
    categoriesType,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String iconCodePoint = 'icon_code_point';
  static const String categoriesType = 'categories_type';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Category {
  final int? id;
  final String title;
  final int iconCodePoint;
  final int categoriesType;
  final String createdAt;
  final String updatedAt;

  const Category({
    this.id,
    required this.title,
    required this.iconCodePoint,
    required this.categoriesType,
    required this.createdAt,
    required this.updatedAt,
  });

  Future<Category> copy({
    int? id,
    String? title,
    int? iconCodePoint,
    int? categoriesType,
    String? createdAt,
    String? updatedAt,
  }) async {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      categoriesType: categoriesType ?? this.categoriesType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Category fromJson(Map<String, Object?> json) => Category(
        id: json[CategoryFields.id] as int?,
        title: json[CategoryFields.title] as String,
        iconCodePoint: json[CategoryFields.iconCodePoint] as int,
        categoriesType: json[CategoryFields.categoriesType] as int,
        createdAt: json[CategoryFields.createdAt] as String,
        updatedAt: json[CategoryFields.updatedAt] as String,
      );

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.title: title,
        CategoryFields.iconCodePoint: iconCodePoint,
        CategoryFields.categoriesType: categoriesType,
        CategoryFields.createdAt: createdAt,
        CategoryFields.updatedAt: updatedAt,
      };

  Map<String, Object?> toJsonBackup() => {
        CategoryFields.id: id,
        CategoryFields.title: title,
        CategoryFields.iconCodePoint: iconCodePoint,
        CategoryFields.categoriesType: categoriesType,
        CategoryFields.createdAt:
            DateTime.parse(createdAt).toUtc().toIso8601String(),
        CategoryFields.updatedAt:
            DateTime.parse(updatedAt).toUtc().toIso8601String(),
      };
}
