import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// ====================================================================
// File: lib/database/product_database.dart
// A singleton for managing SQLite operations.
// ====================================================================

class ProductDatabase {
  static const _databaseName = "ProductDatabase.db";
  static const _databaseVersion = 1;

  static const productTable = 'products';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnDescription = 'description';
  static const columnImageUrl = 'imageUrl';

  // Make this a singleton class
  ProductDatabase._privateConstructor();
  static final ProductDatabase instance = ProductDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $productTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPrice REAL NOT NULL,
            $columnDescription TEXT,
            $columnImageUrl TEXT
          )
          ''');
  }

  // Insert a product into the database
  Future<int> insertProduct(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(productTable, row);
  }

  // Get all products from the database
  Future<List<Map<String, dynamic>>> getProducts() async {
    Database db = await instance.database;
    return await db.query(productTable);
  }

  // Delete all products
  Future<int> deleteAllProducts() async {
    Database db = await instance.database;
    return await db.delete(productTable);
  }
}