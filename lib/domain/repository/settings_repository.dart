import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:flutter/widgets.dart';

abstract class SettingsRepository {
  Future<void> initAsyncData();

  Stream<bool> get isAuthStream;

  bool get isAuth;

  Stream<AppThemeMode> get themeModeStream;

  AppThemeMode get themeMode;

  void setThemeMode(AppThemeMode mode);

  Stream<Locale> get localeStream;

  Locale get locale;

  void setLocale(Locale locale);

  Future<String?> getToken();

  Future<void> setToken(String? token);
}

