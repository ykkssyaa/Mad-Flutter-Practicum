import 'dart:async';

import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final List<NewsModel> _cache = <NewsModel>[];

  @override
  Future<List<NewsModel>> getNewsList() async {
    if (_cache.isNotEmpty) return _cache;

    final now = DateTime.now();
    final List<NewsModel> items = List<NewsModel>.generate(
      4,
      (i) => NewsModel(
        title: 'News #$i',
        link: 'https://example.com/news/$i',
        date: now.subtract(Duration(hours: i * 3)),
      ),
    );

    _cache.addAll(items);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _cache;
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    _cache
      ..clear()
      ..addAll(value);
  }
}
