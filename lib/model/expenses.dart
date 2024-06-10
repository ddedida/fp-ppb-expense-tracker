const tableExpenses = 'expenses';

enum ExpenseType {
  expense(0),
  income(1),
  savings(2);

  const ExpenseType(this.value);
  final int value;
}

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
  final DateTime date;
  final int typeId;
  final String? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    DateTime? date,
    int? typeId,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
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

  static Expense empty() => Expense(
        id: null,
        title: '',
        amount: 0.0,
        date: DateTime.now(),
        typeId: 0,
        categoryId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static Expense fromJson(Map<String, Object?> json) => Expense(
        id: json[ExpenseFields.id] as int,
        title: json[ExpenseFields.title] as String,
        amount: json[ExpenseFields.amount] as double,
        date: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json[ExpenseFields.date] as String)),
        typeId: json[ExpenseFields.typeId] as int,
        categoryId: json[ExpenseFields.categoryId] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json[ExpenseFields.createdAt] as String)),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json[ExpenseFields.updatedAt] as String)),
      );

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.title: title,
        ExpenseFields.amount: amount,
        ExpenseFields.date: date.millisecondsSinceEpoch,
        ExpenseFields.typeId: typeId,
        ExpenseFields.categoryId: categoryId,
        ExpenseFields.createdAt: createdAt.millisecondsSinceEpoch,
        ExpenseFields.updatedAt: updatedAt.millisecondsSinceEpoch,
      };
}
