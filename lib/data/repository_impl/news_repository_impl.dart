import 'package:flutter/foundation.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final List<NewsModel> _cache = <NewsModel>[];
  late final RestDatasource _restDatasource = RestDatasourceImpl();

  @override
  Future<List<NewsModel>> getNewsList() async {
    debugPrint('[NewsRepository] getNewsList called');

    if (_cache.isNotEmpty) {
      debugPrint('[NewsRepository] Returning cached news: ${_cache.length} items');
      return _cache;
    }

    try {
      debugPrint('[NewsRepository] Fetching from REST datasource');
      final List<NewsModel> items = await _restDatasource.getNewsList();

      debugPrint('[NewsRepository] REST returned ${items.length} news items');

      // Если парсер вернул пустой список — считаем это ошибкой сети/парсинга и
      // используем fallback (mock) данные из catch-блока.
      if (items.isEmpty) {
        debugPrint('[NewsRepository] Empty list from REST, treating as error');
        throw Exception('Empty news list from remote');
      }

      _cache.addAll(items);
      debugPrint('[NewsRepository] Cache updated, total: ${_cache.length}');
      return _cache;
    } catch (e) {
      debugPrint('[NewsRepository] Error fetching news: $e');
      // Fallback to mock data if API fails
      final now = DateTime.now();
      final List<NewsModel> items = List<NewsModel>.generate(
        4,
        (i) => NewsModel(
          title: 'News #$i',
          link: 'https://example.com/news/$i',
          date: now.subtract(Duration(hours: i * 3)),
        ),
      );
      debugPrint('[NewsRepository] Using mock data: ${items.length} items');
      _cache.addAll(items);
      return _cache;
    }
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    final List<NewsModel> items = List<NewsModel>.from(value, growable: false);
    _cache
      ..clear()
      ..addAll(items);
  }
}
