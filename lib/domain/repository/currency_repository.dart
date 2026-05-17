import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/model/currency_history_item.dart';

abstract interface class CurrencyRepository {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<void> saveCurrencyList(List<CurrencyModel> value);

  Future<void> saveCurrencyHistory(String currencyId, List<CurrencyHistoryItem> value);

  Future<List<CurrencyHistoryItem>> getCurrencyHistory(String currencyId);

  /// Force refresh data from REST datasource and update local storage & history
  Future<List<CurrencyModel>> refreshCurrencyList();
}

