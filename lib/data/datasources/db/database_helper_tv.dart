import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperTv {
  static DatabaseHelperTv? _databaseHelperTv;

  DatabaseHelperTv._instance() {
    _databaseHelperTv = this;
  }

  factory DatabaseHelperTv() => _databaseHelperTv ?? DatabaseHelperTv._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchListTv = "watchlist_tv";

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton_tv_series.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $_tblWatchListTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        posterPath TEXT,
        overview TEXT
       );
    """);
  }

  Future<int> insertWatchList(TvTable tvSeries) async {
    final db = await database;
    return await db!.insert(_tblWatchListTv, tvSeries.toJson());
  }

  Future<int> removeWatchList(TvTable tvSeries) async {
    final db = await database;
    return await db!.delete(
      _tblWatchListTv,
      where: 'id = ?',
      whereArgs: [tvSeries.id]
    );
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchListTv,
      where: 'id = ?',
      whereArgs: [id]
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchListTv);

    return results;
  }
}