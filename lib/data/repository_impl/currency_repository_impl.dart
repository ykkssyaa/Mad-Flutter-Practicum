
import 'package:flutter/foundation.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasource_impl/sqflite_datasource_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_history_item.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final List<CurrencyModel> _cache = <CurrencyModel>[];
  late final RestDatasource _restDatasource = RestDatasourceImpl();
  late final DbDatasource _dbDatasource = SqfliteDatasourceImpl();

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    debugPrint('[CurrencyRepository] getCurrencyList called');

    if (_cache.isNotEmpty) {
      debugPrint('[CurrencyRepository] Returning cached currencies: ${_cache.length} items');
      return _cache;
    }

    try {
      debugPrint('[CurrencyRepository] Fetching from REST datasource');
      final List<CurrencyModel> items = await _restDatasource.getCurrencyList();

      debugPrint('[CurrencyRepository] REST returned ${items.length} currencies');
      _cache.addAll(items);
      debugPrint('[CurrencyRepository] Cache updated, total: ${_cache.length}');

      // Сохраняем список в локальное хранилище
      await _dbDatasource.saveCurrencyList(items);

      // Для каждой валюты добавляем запись в историю (текущее значение)
      for (final CurrencyModel c in items) {
        try {
          final List<CurrencyHistoryItem> existing = await _dbDatasource.getCurrencyHistory(c.id);
          final List<CurrencyHistoryItem> updated = List<CurrencyHistoryItem>.from(existing);
          updated.insert(0, CurrencyHistoryItem(date: DateTime.now(), value: c.value));
          // Ограничим историю, например, 100 записей
          if (updated.length > 100) updated.removeRange(100, updated.length);
          await _dbDatasource.saveCurrencyHistory(c.id, updated);
        } catch (e) {
          debugPrint('[CurrencyRepository] Error saving history for ${c.id}: $e');
        }
      }

      return _cache;
    } catch (e) {
      debugPrint('[CurrencyRepository] Error fetching currencies: $e');
      // Fallback to mock data if API fails
      final List<CurrencyModel> items = List<CurrencyModel>.generate(
        6,
        (i) => CurrencyModel(
          id: 'id_$i',
          nominal: 1,
          name: ['US Dollar', 'Euro', 'Pound', 'Yen', 'Ruble', 'Franc'][i % 6],
          symbol: ['USD', 'EUR', 'GBP', 'JPY', 'RUB', 'CHF'][i % 6],
          value: 100.0 - i * 3.14,
          previousValue: 100.0 - i * 3.0,
        ),
      );
      debugPrint('[CurrencyRepository] Using mock data: ${items.length} items');
      _cache.addAll(items);
      return _cache;
    }
  }

  @override
  Future<List<CurrencyModel>> refreshCurrencyList() async {
    debugPrint('[CurrencyRepository] refreshCurrencyList called');
    try {
      final List<CurrencyModel> items = await _restDatasource.getCurrencyList();

      debugPrint('[CurrencyRepository] REST returned ${items.length} currencies (refresh)');
      _cache
        ..clear()
        ..addAll(items);

      await _dbDatasource.saveCurrencyList(items);

      for (final CurrencyModel c in items) {
        try {
          final List<CurrencyHistoryItem> existing = await _dbDatasource.getCurrencyHistory(c.id);
          final List<CurrencyHistoryItem> updated = List<CurrencyHistoryItem>.from(existing);
          updated.insert(0, CurrencyHistoryItem(date: DateTime.now(), value: c.value));
          if (updated.length > 100) updated.removeRange(100, updated.length);
          await _dbDatasource.saveCurrencyHistory(c.id, updated);
        } catch (e) {
          debugPrint('[CurrencyRepository] Error saving history for ${c.id} during refresh: $e');
        }
      }

      return _cache;
    } catch (e) {
      debugPrint('[CurrencyRepository] Error refreshing currencies: $e');
      return _cache;
    }
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) async {
    final List<CurrencyModel> items = List<CurrencyModel>.from(value, growable: false);
    _cache
      ..clear()
      ..addAll(items);
  }

  @override
  Future<void> saveCurrencyHistory(String currencyId, List<CurrencyHistoryItem> value) async {
    try {
      await _dbDatasource.saveCurrencyHistory(currencyId, value);
    } catch (e) {
      debugPrint('[CurrencyRepository] saveCurrencyHistory error: $e');
    }
  }

  @override
  Future<List<CurrencyHistoryItem>> getCurrencyHistory(String currencyId) async {
    try {
      return await _dbDatasource.getCurrencyHistory(currencyId);
    } catch (e) {
      debugPrint('[CurrencyRepository] getCurrencyHistory error: $e');
      return const <CurrencyHistoryItem>[];
    }
  }
}

