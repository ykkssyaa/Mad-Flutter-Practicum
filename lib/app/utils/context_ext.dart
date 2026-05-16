import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/gen/l10n/app_localizations.dart';
import 'package:mad_flutter_practicum/app/gen/l10n/app_localizations_ru.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';

final _cachedTheme = AppThemeData.light();

final _cachedLocale = AppLocalizationsRu();

extension ThemeContextExtension on BuildContext {
  AppThemeData get theme => Theme.of(this).extension<AppThemeData>() ?? _cachedTheme;

  ThemeColors get colors => theme.themeColors;

  ThemeFonts get fonts => theme.themeFonts;

  AppLocalizations get loc => AppLocalizations.of(this) ?? _cachedLocale;
}
