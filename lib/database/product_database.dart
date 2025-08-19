import 'package:path/path.dart';
import '../models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProductDatabase {
  static const _databaseName = "ProductDatabase.db";
  static const _databaseVersion = 2; // incremented

  static const productTable = 'products';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnDescription = 'description';
  static const columnImageUrl = 'image';
  static const columnCategory = 'category';

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
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPrice REAL NOT NULL,
        $columnDescription TEXT,
        $columnImageUrl TEXT,
        $columnCategory TEXT
      )
    ''');
    await insertInitialProducts(db);
  }

  Future<void> insertInitialProducts(Database db) async {
    final initialProducts = [
      {
        columnName: "Night Cream",
        columnPrice: 20.0,
        columnImageUrl: "assets/images/night_cream_1.jpg",
        columnCategory: "Night cream",
        columnDescription: "Use during the night",
      },
      {
        columnName: "Night Cream",
        columnPrice: 15.0,
        columnImageUrl: "assets/images/night_cream_2.jpg",
        columnCategory: "Night cream",
        columnDescription: "Use during the night",
      },
      {
        columnName: "Night Cream",
        columnPrice: 10.0,
        columnImageUrl: "assets/images/night_cream_3.jpg",
        columnCategory: "Night cream",
        columnDescription: "Use during the night",
      },
      {
        columnName: "Lip Stain",
        columnPrice: 15.0,
        columnImageUrl: "assets/images/lip_stain_1.jpg",
        columnCategory: "Lip Stain",
        columnDescription: "Use on your lip",
      },
      {
        columnName: "Lip Stain",
        columnPrice: 10.0,
        columnImageUrl: "assets/images/lip_stain_2.jpg",
        columnCategory: "Lip Stain",
        columnDescription: "Use on your lip",
      },
      {
        columnName: "Lip Stain",
        columnPrice: 5.0,
        columnImageUrl: "assets/images/lip_stain_3.jpg",
        columnCategory: "Lip Stain",
        columnDescription: "Use on your lip",
      },
      {
        columnName: "Day Cream",
        columnPrice: 15.0,
        columnImageUrl: "assets/images/day_cream_1.jpg",
        columnCategory: "Day Cream",
        columnDescription: "Use during the day",
      },
      {
        columnName: "Day Cream",
        columnPrice: 5.0,
        columnImageUrl: "assets/images/day_cream_2.jpg",
        columnCategory: "Day Cream",
        columnDescription: "Use during the day",
      },
      {
        columnName: "Day Cream",
        columnPrice: 10.0,
        columnImageUrl: "assets/images/day_cream_3.jpg",
        columnCategory: "Day Cream",
        columnDescription: "Use during the day",
      },
    ];

    for (var product in initialProducts) {
      await db.insert(productTable, product);
    }
  }

  Future<void> insertDemoProductsIfEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $productTable'),
    );
    if (count == 0) {
      await insertInitialProducts(db);
    }
  }

  // ===================== CRUD OPERATIONS =====================

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(productTable, product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query(productTable);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final result = await db.query(
      productTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      productTable,
      product.toMap(),
      where: '$columnId = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      productTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllProducts() async {
    final db = await database;
    return await db.delete(productTable);
  }

  Future<List<Product>> searchProducts(String keyword) async {
    final db = await database;
    final result = await db.query(
      productTable,
      where: '$columnName LIKE ? OR $columnCategory LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return result.map((map) => Product.fromMap(map)).toList();
  }
}
