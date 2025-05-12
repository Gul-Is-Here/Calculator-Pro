// repositories/history_repository.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/calculation.dart';

class HistoryRepository {
  static const _databaseName = 'calculator.db';
  static const _databaseVersion = 1;
  static const table = 'calculations';
  
  static const columnId = 'id';
  static const columnExpression = 'expression';
  static const columnResult = 'result';
  static const columnTimestamp = 'timestamp';
  static const columnIsFavorite = 'isFavorite';
  
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnExpression TEXT NOT NULL,
        $columnResult TEXT NOT NULL,
        $columnTimestamp INTEGER NOT NULL,
        $columnIsFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
  
  Future<int> insertCalculation(Calculation calculation) async {
    final db = await database;
    return await db.insert(table, calculation.toMap());
  }
  
  Future<List<Calculation>> getAllCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: '$columnTimestamp DESC',
    );
    return List.generate(maps.length, (i) => Calculation.fromMap(maps[i]));
  }
  
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      table,
      {columnIsFavorite: isFavorite ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
  
  Future<int> deleteCalculation(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
  
  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete(table);
  }
  
  Future<List<Calculation>> searchCalculations(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnExpression LIKE ? OR $columnResult LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: '$columnTimestamp DESC',
    );
    return List.generate(maps.length, (i) => Calculation.fromMap(maps[i]));
  }
}