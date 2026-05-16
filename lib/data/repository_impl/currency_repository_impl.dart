
import 'package:flutter/foundation.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final List<CurrencyModel> _cache = <CurrencyModel>[];
  late final RestDatasource _restDatasource = RestDatasourceImpl();

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
  Future<void> saveCurrencyList(List<CurrencyModel> value) async {
    final List<CurrencyModel> items = List<CurrencyModel>.from(value, growable: false);
    _cache
      ..clear()
      ..addAll(items);
  }
}

