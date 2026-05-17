// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Mad Flutter Practicum';

  @override
  String get login => 'Войти';

  @override
  String get loginTitle => 'Вход в приложение';

  @override
  String get loginSubtitle =>
      'Войдите, чтобы просматривать актуальные курсы валют и новости.';

  @override
  String get logout => 'Выйти';

  @override
  String get currencyRate => 'Курс валют';

  @override
  String get news => 'Новости';

  @override
  String get profile => 'Профиль';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get system => 'Системная';

  @override
  String get search => 'Поиск';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'Английский';

  @override
  String get german => 'Немецкий';

  @override
  String get historyUnavailable => 'История недоступна';

  @override
  String get dataRefreshFailed => 'Не удалось обновить данные';

  @override
  String get currencyLoadFailedTryLater =>
      'Не удалось загрузить курсы валют. Попробуйте позже.';

  @override
  String get currencyLoadFailed => 'Не удалось загрузить курсы валют.';

  @override
  String get currencyNotFound => 'Курсы валют не найдены.';

  @override
  String get newsLoadFailedTryLater =>
      'Не удалось загрузить новости. Попробуйте позже.';

  @override
  String get newsLoadFailed => 'Не удалось загрузить новости.';

  @override
  String get sourceCbr => 'cbr.ru';

  @override
  String asNominal(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '($value штуки)',
      many: '($value штук)',
      few: '($value штуки)',
      one: '($value штука)',
    );
    return '$_temp0';
  }
}
