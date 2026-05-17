import 'package:flutter/foundation.dart';
import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';

import 'widgets/widgets.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> with SingleTickerProviderStateMixin {
  // Инициализируем пустым списком, чтобы избежать ошибок при dispose до получения данных
  late final ValueNotifier<List<CurrencyModel>> _filteredCurrenciesNotifier = ValueNotifier(const <CurrencyModel>[]);

  late final AnimationController _fadeController;

  late Future<List<CurrencyModel>> _currencyListFuture;

  List<CurrencyModel> _allCurrencies = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initData();
  }

  @override
  void dispose() {
    _filteredCurrenciesNotifier.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  void _initData() {
    final currencyRepository = context.read<CurrencyRepository>();

    debugPrint('[CurrencyListPage] _initData: Starting data fetch');
    _currencyListFuture = currencyRepository.getCurrencyList().then((List<CurrencyModel> value) {
      debugPrint('[CurrencyListPage] _initData.then: Received ${value.length} currencies, returning them');
      _allCurrencies = value;
      _filteredCurrenciesNotifier.value = value;

      _fadeController.forward(); // запускаем анимацию

      currencyRepository.saveCurrencyList(value);
      debugPrint('[CurrencyListPage] _initData.then: Saved to storage, returning value with ${value.length} items');

      return value;
    }).catchError((e) {
      debugPrint('[CurrencyListPage] _initData.catchError: Error during fetch: $e');
      throw e;
    });
    debugPrint('[CurrencyListPage] _initData: Future assigned, future ref: $_currencyListFuture');
  }

  void _filterCurrencies(String query) {
    final String lowerQuery = query.toLowerCase();
    final Iterable<CurrencyModel> result = _allCurrencies.where((CurrencyModel currency) {
      return currency.name.toLowerCase().contains(lowerQuery) || currency.symbol.toLowerCase().contains(lowerQuery);
    });

    _filteredCurrenciesNotifier.value = result.toList(growable: false);
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    final currencyRepository = context.read<CurrencyRepository>();
    try {
      final List<CurrencyModel> refreshed = await currencyRepository.refreshCurrencyList();

      _allCurrencies = refreshed;
      _filteredCurrenciesNotifier.value = refreshed;

      // restart animation
      _fadeController.reset();
      _fadeController.forward();
    } catch (e) {
      debugPrint('[CurrencyListPage] _refreshData error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.loc.dataRefreshFailed)));
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.currencyRate),
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshData,
            ),
        ],
      ),
      body: FutureBuilder<List<CurrencyModel>>(
        future: _currencyListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<CurrencyModel>> snapshot) {
          debugPrint('[CurrencyListPage] FutureBuilder builder called:');
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
              title: context.loc.currencyRate,
              message: context.loc.currencyLoadFailedTryLater,
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FadeTransition(
            opacity: _fadeController.view,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                  child: SearchView(onChanged: _filterCurrencies),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<CurrencyModel>>(
                    valueListenable: _filteredCurrenciesNotifier,
                    builder: (BuildContext context, List<CurrencyModel> data, _) {
                      if (_allCurrencies.isEmpty) {
                        return _StateMessage(
                          title: context.loc.currencyRate,
                          message: context.loc.currencyLoadFailed,
                        );
                      }

                      if (data.isEmpty) {
                        return _StateMessage(
                          title: context.loc.currencyRate,
                          message: context.loc.currencyNotFound,
                        );
                      }

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final CurrencyModel currency = data[index];

                          return Padding(
                            key: ValueKey(currency.id),
                            padding: index == 0 ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 10),
                            child: CurrencyCard(model: currency),
                          );
                        },
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 40),
                      );
                    },
                  ),
                ),
              ],
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

