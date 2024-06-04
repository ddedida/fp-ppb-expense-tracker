import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../model/categories.dart';

class CategoriesDatabases {
  static final CategoriesDatabases instance = CategoriesDatabases._init();

  static Database? _database;

  CategoriesDatabases._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('categories.db');
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
        drop table if exists $tableCategories
      ''');
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCategories (
        ${CategoryFields.id} $idType,
        ${CategoryFields.title} $textType,
        ${CategoryFields.iconCodePoint} $integerType,
        ${CategoryFields.categoriesType} $integerType,
        ${CategoryFields.createdAt} $textType,
        ${CategoryFields.updatedAt} $textType
      )
    ''');
  }

  Future<Category> create(Category category) async {
    final db = await instance.database;
    final id = category.id ?? const Uuid().v4().toString();
    category = await category.copy(id: id);
    await db.insert(tableCategories, category.toJson());
    return category.copy(id: id);
  }

  Future<Category> readCategory(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCategories,
      columns: CategoryFields.values,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Category>> readAllCategories() async {
    final db = await instance.database;

    final result = await db.query(tableCategories);

    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future<int> update(Category category) async {
    final db = await instance.database;

    return db.update(
      tableCategories,
      category.toJson(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCategories,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    _database = null;

    db.close();
  }
}
