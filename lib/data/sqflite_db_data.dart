import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDbData {
  String dbName = 'book.db';
  static final SqfliteDbData instance = SqfliteDbData._();

  SqfliteDbData._();

  Future<Database> get database async {
    final path = await getDatabasesPath();

    final dbPath = join(path, dbName);

    final exists = await databaseExists(dbPath);
    if (!exists) {
      // ignore: avoid_print
      print('Creating new database at $dbPath');
    }
    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final doubleType = 'DOUBLE NOT NULL';
    final nullType = 'TEXT';
    String bookSql = '''
      CREATE TABLE IF NOT EXISTS ${DBConstant.bookTbl} (
        id $idType,
        title $textType,
        description $nullType,
        price $doubleType,
        discount $doubleType,
        author $textType
      )
    ''';
    db.execute(bookSql);
  }
}

class DBConstant{
  static final String bookTbl = 'books';
}