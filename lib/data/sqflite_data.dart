import 'package:sqflite/sqflite.dart';

class SqfliteData {
  static final SqfliteData instance = SqfliteData._();

  // ignore: unused_field
  static final Database? _database;
  SqfliteData._();

  Future<Database> get database async {
    return await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    throw UnimplementedError('_openDatabase has not been implemented.');
  }
}
