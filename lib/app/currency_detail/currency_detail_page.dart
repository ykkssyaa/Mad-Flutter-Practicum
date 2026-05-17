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
        title: Text(widget.model?.name ?? widget.title ?? ''),
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
                return const Center(child: Text('История недоступна'));
              }

              return Column(
                children: [
                  for (int i = 0; i < history.length; i++)
                    Padding(
                      padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
                      child: CurrencyInfoCard(
                        dateTime: history[i].date,
                        value: history[i].value,
                        previousValue: i > 0 ? history[i - 1].value : null,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
