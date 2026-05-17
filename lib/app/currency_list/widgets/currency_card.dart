import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/app/currency_detail/currency_detail_page.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:intl/intl.dart';

enum PriceChange {
  up,
  down,
  stable;
}

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({super.key, required this.model});

  final CurrencyModel model;

  static final _tweenAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);

  @override
  Widget build(BuildContext context) {
    final PriceChange priceChange = model.asPriceChange;
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    final NumberFormat priceFormat = NumberFormat.decimalPattern(localeTag);
    final String localizedPrice = priceFormat.format(model.value);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return CurrencyDetailPage(model: model);
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const Cubic curve = Curves.ease;

              final Animatable<Offset> tween = _tweenAnimation.chain(CurveTween(curve: curve));
              final Animation<Offset> offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: colors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CurrencyIcon(title: model.symbol),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.currencyName(model),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: fonts.semiBold12.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.loc.asNominal(model.nominal),
                      style: fonts.regular12.copyWith(color: colors.tin),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  localizedPrice,
                  style: fonts.semiBold12.copyWith(
                    fontSize: 16,
                    color: switch (priceChange) {
                      PriceChange.up => colors.greenWrasse,
                      PriceChange.down => colors.red,
                      PriceChange.stable => colors.stormyGrey,
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(
                      switch (priceChange) {
                        PriceChange.up => 'assets/icons/arrow_up.png',
                        PriceChange.down => 'assets/icons/arrow_down.png',
                        PriceChange.stable => 'assets/icons/arrow_up.png',
                      },
                      width: 12,
                      height: 12,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      model.symbol,
                      style: fonts.regular12.copyWith(color: colors.tin),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyIcon extends StatelessWidget {
  const CurrencyIcon({super.key, required this.title});

  final String title;

  static Color _colorForTitle(String title) {
    final String normalized = title.trim().toUpperCase();
    int hash = 0;

    for (final int codeUnit in normalized.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= (hash >> 6);
    }

    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= (hash >> 11);
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));

    final double hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1, hue, 0.62, 0.48).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _colorForTitle(title);
    final Color foregroundColor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Container(
      constraints: BoxConstraints.tight(const Size.square(44)),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          title,
          style: context.fonts.semiBold12.copyWith(color: foregroundColor, fontSize: 13),
        ),
      ),
    );
  }
}

extension on CurrencyModel {
  PriceChange get asPriceChange {
    if (value > previousValue) return PriceChange.up;
    if (value < previousValue) return PriceChange.down;

    return PriceChange.stable;
  }
}
