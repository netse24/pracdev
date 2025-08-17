import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// ====================================================================
// File: lib/utils/db_debug_tools.dart
// A simple utility for debugging database operations.
// ====================================================================

class DbDebugTools {
  static Future<void> deleteDatabaseFile() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "ProductDatabase.db");
    await deleteDatabase(path);
  }
}
