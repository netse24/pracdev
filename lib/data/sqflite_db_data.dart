import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:procdev/model/db_constant.dart'; // Import your constants
import 'package:procdev/model/product.dart'; // Import your new model

class SqfliteDbData {
  // String dbName = 'book.db';
  String dbName = 'products.db';
  final List<Map<String, String>> allProducts = [
    {
      "name": "Night Cream - Hydrating",
      "price": "12",
      "image": "assets/images/night_cream_1.jpg",
      "category": "Night cream",
      "description": "The product is great for the people"
    },
    {
      "name": "Night Cream - Anti-Aging",
      "price": "14",
      "image": "assets/images/night_cream_2.jpg",
      "category": "Night cream",
      "description": "The product is great for the people"
    },
    {
      "name": "Night Cream - Brightening",
      "price": "16",
      "image": "assets/images/night_cream_3.jpg",
      "category": "Night cream",
      "description": "The product is great for the people"
    },
    {
      "name": "Day Cream - SPF 30",
      "price": "10",
      "image": "assets/images/day_cream_1.jpg",
      "category": "Day cream"
    },
    {
      "name": "Day Cream - Moisturizing",
      "price": "11",
      "image": "assets/images/day_cream_2.jpg",
      "category": "Day cream",
      "description": "The product is great for the people"
    },
    {
      "name": "Day Cream - Vitamin C",
      "price": "13",
      "image": "assets/images/day_cream_3.jpg",
      "category": "Day cream",
      "description": "The product is great for the people"
    },
    {
      "name": "Lip Stain - Cherry Red",
      "price": "15",
      "image": "assets/images/lip_stain_1.jpg",
      "category": "Lip Stain",
      "description": "The product is great for the people"
    },
    {
      "name": "Lip Stain - Nude Pink",
      "price": "16",
      "image": "assets/images/lip_stain_2.jpg",
      "category": "Lip Stain",
      "description": "The product is great for the people"
    },
    {
      "name": "Lip Stain - Coral Orange",
      "price": "17",
      "image": "assets/images/lip_stain_3.jpg",
      "category": "Lip Stain",
      "description": "The product is great for the people"
    },
  ];
  static final SqfliteDbData instance = SqfliteDbData._();
  SqfliteDbData._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, dbName);
    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final nullableTextType = 'TEXT';
    final doubleType = 'DOUBLE NOT NULL';

    final String createProductTableSql = '''
      CREATE TABLE ${DBConstant.productTbl} (
        ${DBConstant.colId} $idType,
        ${DBConstant.colName} $textType,
        ${DBConstant.colPrice} $doubleType,
        ${DBConstant.colImage} $textType,
        ${DBConstant.colCategory} $textType,
        ${DBConstant.colDescription} $nullableTextType
      )
    ''';

    await db.execute(createProductTableSql);
    await _populateDb(db);
  }

  Future<void> _populateDb(Database db) async {
    for (var productMap in allProducts) {
      // The initial data is already in Map format, so we can insert it directly.
      await db.insert(DBConstant.productTbl, productMap);
    }
  }

  // --- CRUD Methods Using the Product Model ---

  /// Inserts a new product into the database.
  Future<Product> createProduct(Product product) async {
    final db = await instance.database;
    // Use the model's toMap() method to convert the object for insertion.
    final id = await db.insert(DBConstant.productTbl, product.toMap());
    // Return a new product instance with the generated ID.
    return Product(
      id: id,
      name: product.name,
      price: product.price,
      image: product.image,
      category: product.category,
      description: product.description,
    );
  }

  /// Fetches a single product by its ID.
  Future<Product?> getProductById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      DBConstant.productTbl,
      where: '${DBConstant.colId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      // Use the factory constructor to convert the map to a Product object.
      return Product.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Fetches all products from the database.
  /// **This method now returns a Future<List<Product>>.**
  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final maps = await db.query(DBConstant.productTbl);

    // Convert the List<Map<String, dynamic>> to a List<Product>.
    return maps.map((json) => Product.fromMap(json)).toList();
  }

  /// Updates a product.
  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return db.update(
      DBConstant.productTbl,
      product.toMap(),
      where: '${DBConstant.colId} = ?',
      whereArgs: [product.id],
    );
  }

  /// Deletes a product by its ID.
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      DBConstant.productTbl,
      where: '${DBConstant.colId} = ?',
      whereArgs: [id],
    );
  }
}
