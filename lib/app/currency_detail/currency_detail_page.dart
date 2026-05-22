import 'package:mad_flutter_practicum/app/app.dart';

import 'widgets/widgets.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';

class CurrencyDetailPage extends StatefulWidget {
  const CurrencyDetailPage({super.key, this.title, this.model}) : assert(title != null || model != null);

  final String? title;
  final CurrencyModel? model;

  @override
  State<CurrencyDetailPage> createState() => _CurrencyDetailPageState();
}

class _CurrencyDetailPageState extends State<CurrencyDetailPage> {
  double _opacityLevel = 0;

  static const double _defaultLeadingWidth = 56;
  static const double _titleSpacing = 24;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _opacityLevel = 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: _defaultLeadingWidth + _titleSpacing,
        titleSpacing: _titleSpacing,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.model != null ? context.currencyName(widget.model!) : widget.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
        child: AnimatedOpacity(
          opacity: _opacityLevel,
          duration: const Duration(milliseconds: 400),
          child: FutureBuilder<List<CurrencyHistoryItem>>(
            future: widget.model != null
                ? context.read<CurrencyRepository>().getCurrencyHistory(widget.model!.id)
                : Future.value(<CurrencyHistoryItem>[]),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<CurrencyHistoryItem> history = snapshot.data ?? <CurrencyHistoryItem>[];

              if (history.isEmpty) {
                return Center(child: Text(context.loc.historyUnavailable));
              }

              // Use a scrollable ListView instead of Column to avoid RenderFlex overflow
              return ListView.separated(
                itemCount: history.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = history[i];
                  return CurrencyInfoCard(
                    dateTime: item.date,
                    value: item.value,
                    // history is ordered newest first, so the older value is at i+1
                    previousValue: i < history.length - 1 ? history[i + 1].value : null,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
