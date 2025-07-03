import 'package:procdev/data/sqflite_db_data.dart';
import 'package:procdev/model/book.dart';
import 'package:sqflite/sqflite.dart';

class BookService{
  Future<void> insertBook(Book book) async{
    final db = await SqfliteDbData.instance.database;
    db.insert(DBConstant.bookTbl, book.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateBook(Book book) async{
    final db = await SqfliteDbData.instance.database;
    db.update(DBConstant.bookTbl, book.toMap(),where: 'id = ?', conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getBooks() async{
    final db = await SqfliteDbData.instance.database;
    final List<Map<String,dynamic>> results = await db.query(DBConstant.bookTbl);
    List<Book> books = results.map((e)=> Book.fromMap(e)).toList();
    return books;
  }
}