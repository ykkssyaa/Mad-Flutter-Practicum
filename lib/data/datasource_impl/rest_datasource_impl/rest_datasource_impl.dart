import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/app_http_client.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/model/model.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_path.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/model.dart';
import 'package:rss_dart/dart_rss.dart';

class RestDatasourceImpl implements RestDatasource {
  late final AppHttpClient _httpClient = AppHttpClient();

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    debugPrint('[RestDatasource] Fetching currencies from ${RestPath.dailyExchangeRateUrl}');
    final String? response = await _httpClient.getDecodedResponse(RestPath.dailyExchangeRateUrl);

    if (response == null) {
      debugPrint('[RestDatasource] Currency response is null');
      return const <CurrencyModel>[];
    }

    debugPrint('[RestDatasource] Currency response received, length: ${response.length}');

    try {
      final Map<String, dynamic> json = jsonDecode(response);
      debugPrint('[RestDatasource] JSON decoded successfully');

      final dto = CurrencyListResponseDto.fromJson(json);
      final List<CurrencyModel> currencies = dto.valute.values.map((e) => e.model).toList(growable: false);

      debugPrint('[RestDatasource] Parsed ${currencies.length} currencies');
      for (final c in currencies.take(3)) {
        debugPrint('  - [${c.symbol}] ${c.name}: ${c.value}');
      }

      return currencies;
    } catch (e) {
      debugPrint('[RestDatasource] Error parsing currencies: $e');
      return const <CurrencyModel>[];
    }
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    debugPrint('[RestDatasource] Fetching news from ${RestPath.newsUrl}');
    final String? response = await _httpClient.getDecodedResponse(RestPath.newsUrl);

    if (response == null) {
      debugPrint('[RestDatasource] News response is null');
      return const <NewsModel>[];
    }

    debugPrint('[RestDatasource] News response received, length: ${response.length}');

    try {
      final feed = RssFeed.parse(response);
      final List<NewsModel> news = feed.items.map((e) => e.asNewsModel).toList(growable: false);

      debugPrint('[RestDatasource] Parsed ${news.length} news items');
      for (final n in news.take(3)) {
        debugPrint('  - ${n.title} (${n.date})');
      }

      return news;
    } catch (e) {
      debugPrint('[RestDatasource] Error parsing news: $e');
      return const <NewsModel>[];
    }
  }
}

