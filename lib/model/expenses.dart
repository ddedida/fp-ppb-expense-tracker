const tableExpenses = 'expenses';

var expenseType = const <int, String>{
  1: "Pengeluaran",
  2: "Pemasukan",
};

class ExpenseFields {
  static final List<String> values = [
    id,
    title,
    amount,
    date,
    typeId,
    categoryId,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String typeId = 'typeId';
  static const String categoryId = 'category_id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Expense {
  final int? id;
  final String? title;
  final double amount;
  final String date;
  final int typeId;
  final String? categoryId;
  final String createdAt;
  final String updatedAt;

  const Expense({
    this.id,
    this.title,
    required this.amount,
    required this.date,
    required this.typeId,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  Expense copy({
    int? id,
    String? title,
    double? amount,
    String? date,
    int? typeId,
    String? categoryId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Expense(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        typeId: typeId ?? this.typeId,
        categoryId: categoryId ?? this.categoryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Expense fromJson(Map<String, Object?> json) => Expense(
        id: json[ExpenseFields.id] as int,
        title: json[ExpenseFields.title] as String,
        amount: json[ExpenseFields.amount] as double,
        date: json[ExpenseFields.date] as String,
        typeId: json[ExpenseFields.typeId] as int,
        categoryId: json[ExpenseFields.categoryId] as String,
        createdAt: json[ExpenseFields.createdAt] as String,
        updatedAt: json[ExpenseFields.updatedAt] as String,
      );

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.title: title,
        ExpenseFields.amount: amount,
        ExpenseFields.date: date,
        ExpenseFields.typeId: typeId,
        ExpenseFields.categoryId: categoryId,
        ExpenseFields.createdAt: createdAt,
        ExpenseFields.updatedAt: updatedAt,
      };
}
