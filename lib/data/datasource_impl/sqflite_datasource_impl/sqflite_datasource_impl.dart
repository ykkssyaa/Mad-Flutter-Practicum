import 'dart:io';

import 'dart:convert';
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Реализация DbDatasource, использующая sqlite через sqflite.
class SqfliteDatasourceImpl implements DbDatasource {
  static const _dbFileName = 'mad_practicum.db';

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _dbFileName);

    // ensure directory exists
    try {
      final parent = Directory(path).parent;
      if (!await parent.exists()) await parent.create(recursive: true);
    } catch (_) {}

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE currency_list (
          id TEXT PRIMARY KEY,
          nominal INTEGER,
          name TEXT,
          symbol TEXT,
          value REAL,
          previousValue REAL
        );
      ''');

      await db.execute('''
        CREATE TABLE currency_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          currency_id TEXT,
          date TEXT,
          value REAL
        );
      ''');
    });

    // После открытия БД попытаемся мигрировать старые данные из SharedPreferences
    await _migrateFromSharedPreferences(path);

    return _db!;
  }

  Future<void> _migrateFromSharedPreferences(String dbPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const keyCurrencyList = 'db_currency_list_v1';
      const keyCurrencyHistoryPrefix = 'db_currency_history_v1_';

      // migrate currency list
      final String? listJson = prefs.getString(keyCurrencyList);
      if (listJson != null) {
        final List<dynamic> data = jsonDecode(listJson) as List<dynamic>;
        final List<CurrencyModel> items = data.map((e) => CurrencyModel(
              id: e['id'] as String,
              nominal: e['nominal'] as int,
              name: e['name'] as String,
              symbol: e['symbol'] as String,
              value: (e['value'] as num).toDouble(),
              previousValue: (e['previousValue'] as num).toDouble(),
            )).toList(growable: false);

        await saveCurrencyList(items);
        // remove legacy
        await prefs.remove(keyCurrencyList);
      }

      // migrate histories
      final Set<String> keys = prefs.getKeys();
      for (final String key in keys) {
        if (key.startsWith(keyCurrencyHistoryPrefix)) {
          final String? json = prefs.getString(key);
          if (json == null) continue;
          final String currencyId = key.substring(keyCurrencyHistoryPrefix.length);
          final List<dynamic> data = jsonDecode(json) as List<dynamic>;
          final List<CurrencyHistoryItem> items = data.map((e) => CurrencyHistoryItem.fromMap(e as Map<String, dynamic>)).toList(growable: false);
          await saveCurrencyHistory(currencyId, items);
          await prefs.remove(key);
        }
      }
    } catch (e) {
      // ignore migration errors
    }
  }

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final db = await _database;
    final List<Map<String, Object?>> rows = await db.query('currency_list');
    return rows.map((e) => CurrencyModel(
          id: e['id'] as String,
          nominal: (e['nominal'] as num).toInt(),
          name: e['name'] as String,
          symbol: e['symbol'] as String,
          value: (e['value'] as num).toDouble(),
          previousValue: (e['previousValue'] as num).toDouble(),
        )).toList(growable: false);
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    // News storage not migrated to sqlite in this change — fallback to empty
    return const <NewsModel>[];
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) async {
    final db = await _database;
    final batch = db.batch();
    // replace all entries
    await db.delete('currency_list');
    for (final e in value) {
      batch.insert('currency_list', {
        'id': e.id,
        'nominal': e.nominal,
        'name': e.name,
        'symbol': e.symbol,
        'value': e.value,
        'previousValue': e.previousValue,
      });
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    // Not implemented for sqlite — keep no-op
  }

  @override
  Future<void> saveCurrencyHistory(String currencyId, List<CurrencyHistoryItem> value) async {
    final db = await _database;
    // For simplicity, remove existing history for this currency and insert given list
    final batch = db.batch();
    batch.delete('currency_history', where: 'currency_id = ?', whereArgs: [currencyId]);
    for (final item in value) {
      batch.insert('currency_history', {
        'currency_id': currencyId,
        'date': item.date.toIso8601String(),
        'value': item.value,
      });
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<CurrencyHistoryItem>> getCurrencyHistory(String currencyId) async {
    final db = await _database;
    final List<Map<String, Object?>> rows = await db.query(
      'currency_history',
      where: 'currency_id = ?',
      whereArgs: [currencyId],
      orderBy: 'date DESC',
    );
    return rows.map((e) => CurrencyHistoryItem.fromMap({
          'date': e['date'] as String,
          'value': e['value'] as num,
        })).toList(growable: false);
  }
}

