import 'dart:convert';

import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Упрощённая реализация DbDatasource, сохраняющая списки в SharedPreferences
/// в виде JSON-строк. Подходит для десктоп-миграции как временное решение.
class SqfliteDatasourceImpl implements DbDatasource {
  static const _keyCurrencyList = 'db_currency_list_v1';
  static const _keyNewsList = 'db_news_list_v1';

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_keyCurrencyList);
    if (json == null) return const <CurrencyModel>[];

    final List<dynamic> data = jsonDecode(json) as List<dynamic>;
    return data.map((e) => CurrencyModel(
          id: e['id'] as String,
          nominal: e['nominal'] as int,
          name: e['name'] as String,
          symbol: e['symbol'] as String,
          value: (e['value'] as num).toDouble(),
          previousValue: (e['previousValue'] as num).toDouble(),
        )).toList(growable: false);
  }

   @override
   Future<List<NewsModel>> getNewsList() async {
     final prefs = await SharedPreferences.getInstance();
     final String? json = prefs.getString(_keyNewsList);
     if (json == null) return const <NewsModel>[];

     final List<dynamic> data = jsonDecode(json) as List<dynamic>;
     return data.map((e) => NewsModel(
           title: e['title'] as String,
           link: e['link'] as String,
           date: e['date'] != null ? DateTime.parse(e['date'] as String) : null,
         )).toList(growable: false);
   }

   @override
   Future<void> saveCurrencyList(List<CurrencyModel> value) async {
     final prefs = await SharedPreferences.getInstance();
     final String json = jsonEncode(value.map((e) => {
           'id': e.id,
           'nominal': e.nominal,
           'name': e.name,
           'symbol': e.symbol,
           'value': e.value,
           'previousValue': e.previousValue,
         }).toList(growable: false));

     await prefs.setString(_keyCurrencyList, json);
   }

   @override
   Future<void> saveNewsList(List<NewsModel> value) async {
     final prefs = await SharedPreferences.getInstance();
     final String json = jsonEncode(value.map((e) => {
           'title': e.title,
           'link': e.link,
           'date': e.date?.toIso8601String(),
         }).toList(growable: false));

     await prefs.setString(_keyNewsList, json);
   }
}

