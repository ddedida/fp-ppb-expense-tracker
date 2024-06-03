import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/budget.dart';

class BudgetDatabase {
  static final BudgetDatabase instance = BudgetDatabase._init();

  static Database? _database;

  BudgetDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('budgets.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableBudgets (
        ${BudgetFields.id} $idType,
        ${BudgetFields.amount} $doubleType,
        ${BudgetFields.date} $textType,
        ${BudgetFields.categoryId} $textType,
        ${BudgetFields.createdAt} $textType,
        ${BudgetFields.updatedAt} $textType
      )
    ''');
  }

  Future<Budget> create(Budget budget) async {
    final db = await instance.database;
    final id = await db.insert(tableBudgets, budget.toJson());
    return budget.copy(id: id);
  }

  Future<Budget> readBudget(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBudgets,
      columns: BudgetFields.values,
      where: '${BudgetFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Budget.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Budget>> readAllBudgets() async {
    final db = await instance.database;

    final result = await db.query(tableBudgets);

    return result.map((json) => Budget.fromJson(json)).toList();
  }

  Future<Budget?> readBudgetByCategory(String categoryId) async {
    final db = await instance.database;
    final maps = await db.query(
      tableBudgets,
      where: '${BudgetFields.categoryId} = ?',
      whereArgs: [categoryId],
    );

    if (maps.isNotEmpty) {
      return Budget.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(Budget budget) async {
    final db = await instance.database;

    return db.update(
      tableBudgets,
      budget.toJson(),
      where: '${BudgetFields.id} = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableBudgets,
      where: '${BudgetFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    _database = null;

    db.close();
  }
}
