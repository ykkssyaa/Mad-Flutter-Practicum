import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';

/// Простейшая реализация SettingsRepository для миграции UI: хранит токен и тему в памяти.
class SettingsRepositoryImpl implements SettingsRepository {
  final StreamController<bool> _isAuthController = StreamController<bool>.broadcast();
  final StreamController<AppThemeMode> _themeModeController = StreamController<AppThemeMode>.broadcast();
  final StreamController<Locale> _localeController = StreamController<Locale>.broadcast();

  String? _token;
  AppThemeMode _themeMode = AppThemeMode.system;
  Locale _locale = const Locale('ru');

  @override
  Stream<bool> get isAuthStream => _isAuthController.stream;

  @override
  bool get isAuth => _token != null;

  @override
  Stream<AppThemeMode> get themeModeStream => _themeModeController.stream;

  @override
  AppThemeMode get themeMode => _themeMode;

  @override
  Stream<Locale> get localeStream => _localeController.stream;

  @override
  Locale get locale => _locale;

  @override
  Future<void> initAsyncData() async {
    // Здесь можно загрузить настройки из диска; пока просто эмулируем задержку.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isAuthController.add(isAuth);
    _themeModeController.add(_themeMode);
    _localeController.add(_locale);
  }

  @override
  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    _themeModeController.add(mode);
  }

  @override
  void setLocale(Locale locale) {
    _locale = Locale(locale.languageCode);
    _localeController.add(_locale);
  }

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> setToken(String? token) async {
    _token = token;
    _isAuthController.add(isAuth);
  }

  void dispose() {
    _isAuthController.close();
    _themeModeController.close();
    _localeController.close();
  }
}

