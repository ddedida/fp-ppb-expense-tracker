const tableCategories = 'categories';

class CategoryFields {
  static final List<String> values = [
    id,
    title,
    iconTitle,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String iconTitle = 'iconTitle';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Category {
  final int? id;
  final String? title;
  final String? iconTitle;
  final String createdAt;
  final String updatedAt;

  const Category({
    this.id,
    required this.title,
    required this.iconTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  Category copy({
    int? id,
    String? title,
    String? iconTitle,
    String? createdAt,
    String? updatedAt,
  }) =>
      Category(
        id: id ?? this.id,
        title: title ?? this.title,
        iconTitle: iconTitle ?? this.iconTitle,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Category fromJson(Map<String, Object?> json) => Category(
    id: json[CategoryFields.id] as int,
    title: json[CategoryFields.title] as String,
    iconTitle: json[CategoryFields.iconTitle] as String,
    createdAt: json[CategoryFields.createdAt] as String,
    updatedAt: json[CategoryFields.updatedAt] as String,
  );

  Map<String, Object?> toJson() => {
    CategoryFields.id: id,
    CategoryFields.title: title,
    CategoryFields.iconTitle: iconTitle,
    CategoryFields.createdAt: createdAt,
    CategoryFields.updatedAt: updatedAt,
  };
}
