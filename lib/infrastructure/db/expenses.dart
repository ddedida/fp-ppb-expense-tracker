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

    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS $tableExpenses');
      await _createDB(db, newVersion);
    }
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
    final id = await db.insert(tableExpenses, expense.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableExpenses,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    _database = null;

    db.close();
  }

  Future countByCategoryThenGroupByType() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      '''
      SELECT ${ExpenseFields.categoryId}, COUNT(1) as count
      FROM $tableExpenses
      GROUP BY ${ExpenseFields.categoryId}
    ''',
    );

    return result.toList();
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

  Future<List<Expense>> readAllExpensesByCategory(String categoryId) async {
    final db = await instance.database;

    final result = await db.query(
      tableExpenses,
      where: '${ExpenseFields.categoryId} = ?',
      whereArgs: [categoryId],
    );

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Expense>> readAllExpensesUpdatedAfter(DateTime date) async {
    final db = await instance.database;

    final result = await db.query(
      tableExpenses,
      where: '${ExpenseFields.updatedAt} > ?',
      whereArgs: [date.toIso8601String()],
    );

    return result.map((json) => Expense.fromJson(json)).toList();
  }
}
