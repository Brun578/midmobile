import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const nullableTextType = 'TEXT';

    await db.execute('''
      CREATE TABLE books (
        id $idType,
        title $textType,
        author $textType,
        rating $doubleType,
        isRead $boolType,
        imagePath $nullableTextType,
        pdfPath $nullableTextType
      )
    ''');
  }

  Future<List<Book>> fetchBooks() async {
    final db = await instance.database;
    final result = await db.query('books');
    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> insertBook(Book book) async {
    final db = await instance.database;
    return await db.insert('books', book.toJson());
  }

  Future<int> updateBook(Book book) async {
    final db = await instance.database;
    return await db.update(
      'books',
      book.toJson(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(int id) async {
    final db = await instance.database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
