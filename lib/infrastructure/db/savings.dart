import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../model/savings.dart';

class SavingsDatabases {
  static final SavingsDatabases instance = SavingsDatabases._init();

  static Database? _database;

  SavingsDatabases._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('savings.db');
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
      await db.execute('''
        drop table if exists $tableSavings
      ''');
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableSavings (
        ${SavingsFields.id} $idType,
        ${SavingsFields.title} $textType,
        ${SavingsFields.emoji} $textType,
        ${SavingsFields.target} $doubleType,
        ${SavingsFields.amount} $doubleType,
        ${SavingsFields.createdAt} $textType,
        ${SavingsFields.updatedAt} $textType
      )
    ''');
  }

  Future<Savings> create(Savings savings) async {
    final db = await instance.database;
    final id = await savings.id ?? const Uuid().v4().toString();
    savings = await savings.copy(id: id);
    await db.insert(tableSavings, savings.toJson());
    return savings.copy(id: id);
  }

  Future<Savings> readSavings(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableSavings,
      columns: SavingsFields.values,
      where: '${SavingsFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Savings.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Savings>> readAllSavings() async {
    final db = await instance.database;
    final result = await db.query(tableSavings);

    return result.map((json) => Savings.fromJson(json)).toList();
  }

  Future<int> update(Savings savings) async {
    final db = await instance.database;
    return db.update(
      tableSavings,
      savings.toJson(),
      where: '${SavingsFields.id} = ?',
      whereArgs: [savings.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return db.delete(
      tableSavings,
      where: '${SavingsFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
