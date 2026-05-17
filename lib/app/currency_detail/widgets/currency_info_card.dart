import 'package:intl/intl.dart';
import 'package:mad_flutter_practicum/app/app.dart';

class CurrencyInfoCard extends StatelessWidget {
  const CurrencyInfoCard({super.key, required this.dateTime, required this.value, this.previousValue, this.symbol});

  final DateTime dateTime;
  final double value;
  final double? previousValue;
  final String? symbol;

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;
    final String localeTag = Localizations.localeOf(context).toLanguageTag();

    // determine price change
    final bool isUp = previousValue != null ? value > previousValue! : false;
    final bool isDown = previousValue != null ? value < previousValue! : false;

    final String formattedDate = DateFormat.yMd(localeTag).add_jm().format(dateTime);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 24, 8, 24),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                formattedDate,
                style: fonts.semiBold12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Text(
              '${value.toStringAsFixed(2)}${symbol != null ? ' $symbol' : ''}',
              style: fonts.semiBold12.copyWith(color: isUp ? colors.greenWrasse : isDown ? colors.red : colors.stormyGrey),
            ),
          ),
          Image.asset(
            isUp ? 'assets/icons/arrow_up.png' : isDown ? 'assets/icons/arrow_down.png' : 'assets/icons/arrow_up.png',
            width: 10,
            height: 10,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
