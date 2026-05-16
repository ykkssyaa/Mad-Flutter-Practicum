import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final List<NewsModel> _cache = <NewsModel>[];
  late final RestDatasource _restDatasource = RestDatasourceImpl();

  @override
  Future<List<NewsModel>> getNewsList() async {
    if (_cache.isNotEmpty) return _cache;

    try {
      final List<NewsModel> items = await _restDatasource.getNewsList();
      _cache.addAll(items);
      return _cache;
    } catch (e) {
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
      _cache.addAll(items);
      return _cache;
    }
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) async {
    _cache
      ..clear()
      ..addAll(value);
  }
}
