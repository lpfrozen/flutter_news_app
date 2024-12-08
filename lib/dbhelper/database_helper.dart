import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  // Get the database instance (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'news.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        print('Creating database...');
        await _createTable(db);
        await _insertSampleData(db);
      },
      onUpgrade: _onUpgrade,
    );
  }

  // Create the saved_news table
  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE saved_news(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT,
        author TEXT
      )
    ''');
    print('Table created: saved_news');
  }

  // Handle database upgrade
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion...');
    if (oldVersion < 2) {
      await _addColumnIfNotExists(db, 'saved_news', 'url', 'TEXT');
      await _addColumnIfNotExists(db, 'saved_news', 'content', 'TEXT');
      await _addColumnIfNotExists(db, 'saved_news', 'author', 'TEXT');
    }
  }

  // Add column to table if it does not exist
  Future<void> _addColumnIfNotExists(Database db, String tableName,
      String columnName, String columnType) async {
    try {
      final result = await db.rawQuery('PRAGMA table_info($tableName)');
      final exists = result.any((column) => column['name'] == columnName);
      if (!exists) {
        await db.execute(
            'ALTER TABLE $tableName ADD COLUMN $columnName $columnType');
        print('Added column $columnName to $tableName');
      }
    } catch (e) {
      print('Error adding column $columnName: $e');
    }
  }

  // Insert sample data for testing
  Future<void> _insertSampleData(Database db) async {
    final sampleArticles = [
      {
        'id': '1',
        'title': 'Bitcoin hits record high',
        'description': 'The rapid increase in price has been attributed to...',
        'url': 'https://www.bbc.com/news/articles/cqjz04lv5q9o',
        'urlToImage': 'https://ichef.bbci.co.uk/news/1024/branded_news/d7.jpg',
        'publishedAt': '2024-12-05T13:52:30Z',
        'content':
            'Bitcoin\'s price has blasted through the much-anticipated mark.',
        'author': 'John Doe'
      },
      {
        'id': '2',
        'title': 'AI Revolution in Healthcare',
        'description': 'AI is transforming the healthcare industry...',
        'url': 'https://www.example.com/ai-healthcare',
        'urlToImage': 'https://example.com/images/ai_healthcare.jpg',
        'publishedAt': '2024-12-04T10:00:00Z',
        'content':
            'AI has the potential to significantly improve patient outcomes...',
        'author': 'Jane Smith'
      },
    ];

    final batch = db.batch();
    for (final article in sampleArticles) {
      batch.insert('saved_news', article,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    print('Sample data inserted');
  }

  // Save an article
  Future<void> saveArticle(Article article) async {
    final db = await database;
    try {
      await db.insert(
        'saved_news',
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Article saved: ${article.id}');
    } catch (e) {
      print('Error saving article: $e');
    }
  }

  // Unsave an article
  Future<void> unsaveArticle(String id) async {
    final db = await database;
    try {
      await db.delete(
        'saved_news',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Article unsaved: $id');
    } catch (e) {
      print('Error unsaving article: $e');
    }
  }

  // Fetch all saved articles
  Future<List<Article>> getSavedArticles() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('saved_news');
      return maps.map((map) => Article.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching saved articles: $e');
      return [];
    }
  }

  // Check if an article is saved
  Future<bool> isArticleSaved(String id) async {
    final db = await database;
    try {
      final result = await db.query(
        'saved_news',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking if article is saved: $e');
      return false;
    }
  }
}
