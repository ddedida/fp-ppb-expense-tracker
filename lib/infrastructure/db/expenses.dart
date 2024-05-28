import 'package:sqflite/sqflite.dart';
import '../../model/expenses.dart';

class ExpensesDatabases {
  static final ExpensesDatabases instance = ExpensesDatabases._init();

  static Database? _database;

  ExpensesDatabases._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableExpenses (
        ${ExpenseFields.id} $idType,
        ${ExpenseFields.title} $textType,
        ${ExpenseFields.amount} $doubleType,
        ${ExpenseFields.date} $textType,
        ${ExpenseFields.typeId} $integerType,
        ${ExpenseFields.categoryId} $textType,
        ${ExpenseFields.createdAt} $textType,
        ${ExpenseFields.updatedAt} $textType
      )
    ''');
  }

  Future<Expense> create(Expense expense) async {
    final db = await instance.database;
    final id = await db.insert(tableExpenses, expense.toJson());
    return expense.copy(id: id);
  }

  Future<Expense> readExpense(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableExpenses,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Expense.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Expense>> readAllExpenses() async {
    final db = await instance.database;

    final result = await db.query(tableExpenses);

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await instance.database;

    return db.update(
      tableExpenses,
      expense.toJson(),
      where: '${ExpenseFields.id} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableExpenses,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<List<Expense>> readAllExpensesByType(int type) async {
    final db = await instance.database;

    final result = await db.query(
      tableExpenses,
      where: '${ExpenseFields.typeId} = ?',
      whereArgs: [type],
    );

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Expense>> readAllExpensesByCategory(String category) async {
    final db = await instance.database;

    final result = await db.query(
      tableExpenses,
      where: '${ExpenseFields.categoryId} = ?',
      whereArgs: [category],
    );

    return result.map((json) => Expense.fromJson(json)).toList();
  }
}
