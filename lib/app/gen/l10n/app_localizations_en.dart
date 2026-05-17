// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mad Flutter Practicum';

  @override
  String get login => 'Login';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Sign in to view current exchange rates and latest news.';

  @override
  String get logout => 'Logout';

  @override
  String get currencyRate => 'Exchange rate';

  @override
  String get news => 'News';

  @override
  String get profile => 'Profile';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get search => 'Search';

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get historyUnavailable => 'History is unavailable';

  @override
  String get dataRefreshFailed => 'Failed to refresh data';

  @override
  String get currencyLoadFailedTryLater =>
      'Failed to load exchange rates. Please try again later.';

  @override
  String get currencyLoadFailed => 'Failed to load exchange rates.';

  @override
  String get currencyNotFound => 'No exchange rates found.';

  @override
  String get newsLoadFailedTryLater =>
      'Failed to load news. Please try again later.';

  @override
  String get newsLoadFailed => 'Failed to load news.';

  @override
  String get sourceCbr => 'cbr.ru';

  @override
  String asNominal(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '($value items)',
      one: '($value item)',
    );
    return '$_temp0';
  }
}
