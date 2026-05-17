import 'package:flutter/widgets.dart';
import 'package:mad_flutter_practicum/app/gen/l10n/app_localizations.dart';

extension LocaleExt on Locale {
  String titleOf(AppLocalizations loc) {
    return switch (languageCode) {
      'ru' => loc.russian,
      'en' => loc.english,
      'de' => loc.german,
      _ => languageCode,
    };
  }
}

