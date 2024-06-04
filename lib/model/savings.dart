const tableSavings = 'savings';

class SavingsFields {
  static final List<String> values = [
    id,
    title,
    emoji,
    target,
    amount,
    date,
    createdAt,
    updatedAt,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String emoji = 'emoji';
  static const String target = 'target';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Savings {
  final String? id;
  final String title;
  final String emoji;
  final double target;
  final double amount;
  final int date;
  final int createdAt;
  final int updatedAt;

  const Savings({
    this.id,
    required this.title,
    required this.emoji,
    required this.target,
    required this.amount,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  Future<Savings> copy({
    String? id,
    String? title,
    String? emoji,
    double? target,
    double? amount,
    int? date,
    int? createdAt,
    int? updatedAt,
  }) async {
    return Savings(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      target: target ?? this.target,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Savings fromJson(Map<String, Object?> json) => Savings(
        id: json[SavingsFields.id] as String?,
        title: json[SavingsFields.title] as String,
        emoji: json[SavingsFields.emoji] as String,
        target: json[SavingsFields.target] as double,
        amount: json[SavingsFields.amount] as double,
        date: json[SavingsFields.date] as int,
        createdAt: json[SavingsFields.createdAt] as int,
        updatedAt: json[SavingsFields.updatedAt] as int,
      );

  Map<String, Object?> toJson() => {
        SavingsFields.id: id,
        SavingsFields.title: title,
        SavingsFields.emoji: emoji,
        SavingsFields.target: target,
        SavingsFields.amount: amount,
        SavingsFields.date: date,
        SavingsFields.createdAt: createdAt,
        SavingsFields.updatedAt: updatedAt,
      };
}
