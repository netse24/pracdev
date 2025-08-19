import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class CartDatabase {
  static const _databaseName = "CartDatabase.db";
  static const _databaseVersion = 1;

  static const cartTable = 'cart';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnDescription = 'description';
  static const columnCategory = 'category';
  static const columnImage = 'image';
  static const columnQuantity = 'quantity';

  CartDatabase._privateConstructor();
  static final CartDatabase instance = CartDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $cartTable (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnPrice REAL NOT NULL,
        $columnImage TEXT,
        $columnDescription TEXT,
        $columnCategory TEXT,
        $columnQuantity INTEGER NOT NULL
      )
    ''');
  }

  // ===== CRUD =====
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    return await db.query(cartTable);
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(cartTable, item,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    final db = await database;
    await db.update(
      cartTable,
      {columnQuantity: quantity},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(cartTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete(cartTable);
  }
}
