part of 'profile_page.dart';

class LocaleSelectorBottomSheet extends StatelessWidget {
  const LocaleSelectorBottomSheet._({required this.selectedLocale});

  final Locale selectedLocale;

  static const List<Locale> _locales = <Locale>[
    Locale('ru'),
    Locale('en'),
    Locale('de'),
  ];

  static Future<Locale?> show(BuildContext context, Locale selectedLocale) => showModalBottomSheet(
        context: context,
        builder: (_) => LocaleSelectorBottomSheet._(selectedLocale: selectedLocale),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final Locale locale in _locales)
            RadioListTile<Locale>(
              value: locale,
              groupValue: selectedLocale,
              onChanged: (Locale? locale) {
                if (locale == null) return;

                context.read<SettingsRepository>().setLocale(locale);
                Navigator.pop(context, locale);
              },
              title: Text(
                locale.titleOf(context.loc),
                style: context.fonts.regular16,
              ),
            ),
        ],
      ),
    );
  }
}

