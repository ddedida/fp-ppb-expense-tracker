const tableBudgets = 'budgets';

class BudgetFields {
  static final List<String> values = [
    id,
    amount,
    date,
    categoryId,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String categoryId = 'category_id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Budget {
  final int? id;
  final double amount;
  final String date;
  final String? categoryId;
  final String createdAt;
  final String updatedAt;

  const Budget({
    this.id,
    required this.amount,
    required this.date,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  Budget copy({
    int? id,
    String? title,
    double? amount,
    String? date,
    int? typeId,
    String? categoryId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Budget(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        categoryId: categoryId ?? this.categoryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Budget fromJson(Map<String, Object?> json) => Budget(
        id: json[BudgetFields.id] as int,
        amount: json[BudgetFields.amount] as double,
        date: json[BudgetFields.date] as String,
        categoryId: json[BudgetFields.categoryId] as String,
        createdAt: json[BudgetFields.createdAt] as String,
        updatedAt: json[BudgetFields.updatedAt] as String,
      );

  Map<String, Object?> toJson() => {
        BudgetFields.id: id,
        BudgetFields.amount: amount,
        BudgetFields.date: date,
        BudgetFields.categoryId: categoryId,
        BudgetFields.createdAt: createdAt,
        BudgetFields.updatedAt: updatedAt,
      };
}
