// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mad Flutter Practicum';

  @override
  String get login => 'Anmelden';

  @override
  String get loginTitle => 'Anmeldung';

  @override
  String get loginSubtitle =>
      'Melden Sie sich an, um aktuelle Wechselkurse und Nachrichten zu sehen.';

  @override
  String get logout => 'Abmelden';

  @override
  String get currencyRate => 'Wechselkurs';

  @override
  String get news => 'Nachrichten';

  @override
  String get profile => 'Profil';

  @override
  String get theme => 'Design';

  @override
  String get language => 'Sprache';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get search => 'Suche';

  @override
  String get russian => 'Russisch';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get historyUnavailable => 'Verlauf ist nicht verfugbar';

  @override
  String get dataRefreshFailed => 'Daten konnten nicht aktualisiert werden';

  @override
  String get currencyLoadFailedTryLater =>
      'Wechselkurse konnten nicht geladen werden. Bitte versuchen Sie es spater erneut.';

  @override
  String get currencyLoadFailed => 'Wechselkurse konnten nicht geladen werden.';

  @override
  String get currencyNotFound => 'Keine Wechselkurse gefunden.';

  @override
  String get newsLoadFailedTryLater =>
      'Nachrichten konnten nicht geladen werden. Bitte versuchen Sie es spater erneut.';

  @override
  String get newsLoadFailed => 'Nachrichten konnten nicht geladen werden.';

  @override
  String get sourceCbr => 'cbr.ru';

  @override
  String asNominal(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '($value Stuck)',
      one: '($value Stuck)',
    );
    return '$_temp0';
  }
}
