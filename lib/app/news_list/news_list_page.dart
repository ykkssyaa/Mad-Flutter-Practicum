import 'package:flutter/foundation.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';

import 'widgets/widgets.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> with SingleTickerProviderStateMixin {
  static final _tween = Tween<double>(begin: 0.25, end: 1);

  late Future<List<NewsModel>> _newsListFuture;

  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initData();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = _tween.animate(_scaleController);
  }

  void _initData() {
    final newsRepository = context.read<NewsRepository>();

    debugPrint('[NewsListPage] _initData: Starting data fetch');
    _newsListFuture = newsRepository.getNewsList().then((List<NewsModel> value) {
      debugPrint('[NewsListPage] _initData.then: Received ${value.length} news items, returning them');
      newsRepository.saveNewsList(value);

      _scaleController.forward(); // запускаем анимацию
      debugPrint('[NewsListPage] _initData.then: Saved to storage and animation started, returning value with ${value.length} items');

      return value;
    }).catchError((e) {
      debugPrint('[NewsListPage] _initData.catchError: Error during fetch: $e');
      throw e;
    });
    debugPrint('[NewsListPage] _initData: Future assigned, future ref: $_newsListFuture');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.news)),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
          debugPrint('[NewsListPage] FutureBuilder builder called:');
          debugPrint('  - connectionState: ${snapshot.connectionState}');
          debugPrint('  - hasData: ${snapshot.hasData}');
          debugPrint('  - hasError: ${snapshot.hasError}');
          debugPrint('  - data type: ${snapshot.data.runtimeType}');
          debugPrint('  - data length: ${snapshot.data?.length ?? "null"}');
          if (snapshot.hasError) {
            debugPrint('  - error: ${snapshot.error}');
          }
          
          if (snapshot.hasError) {
            return _StateMessage(
              title: context.loc.news,
              message: 'Не удалось загрузить новости. Попробуйте позже.',
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<NewsModel> data = snapshot.data ?? const <NewsModel>[];

          if (data.isEmpty) {
            return _StateMessage(
              title: context.loc.news,
              message: 'Не удалось загрузить новости.',
            );
          }

          return ScaleTransition(
            scale: _scaleAnimation,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final NewsModel news = data[index];

                return Padding(
                  key: ValueKey(news.link),
                  padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
                  child: NewsCard(model: news),
                );
              },
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
            ),
          );
        },
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.fonts.semiBold12,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.fonts.regular12.copyWith(color: context.colors.tin),
            ),
          ],
        ),
      ),
    );
  }
}

