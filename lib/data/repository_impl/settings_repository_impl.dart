import '../../data/datasource/local_storage.dart';
import '../../domain/repository/settings_repository.dart';
import '../../domain/model/app_theme_mode.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

/// Адаптированная реализация SettingsRepository для существующей data-слоя.
class SettingsRepositoryImpl implements SettingsRepository {
  static const _keyDarkMode = 'settings_dark_mode_v1';
  static const _keyLocale = 'settings_locale_v1';
  final LocalStorage _storage;

  final StreamController<bool> _isAuthController = StreamController<bool>.broadcast();
  final StreamController<AppThemeMode> _themeController = StreamController<AppThemeMode>.broadcast();
  final StreamController<Locale> _localeController = StreamController<Locale>.broadcast();

  String? _token;
  AppThemeMode _themeMode = AppThemeMode.system;
  Locale _locale = const Locale('ru');

  SettingsRepositoryImpl({LocalStorage? storage}) : _storage = storage ?? LocalStorage();

  @override
  Future<void> initAsyncData() async {
    final bool? dark = await _storage.readBool(_keyDarkMode);
    final String? savedLocale = await _storage.readString(_keyLocale);

    _themeMode = (dark == null) ? AppThemeMode.system : (dark ? AppThemeMode.dark : AppThemeMode.light);
    if (savedLocale != null && savedLocale.isNotEmpty) {
      _locale = Locale(savedLocale);
    }

    _themeController.add(_themeMode);
    _localeController.add(_locale);
    _isAuthController.add(isAuth);
  }

  @override
  Stream<bool> get isAuthStream => _isAuthController.stream;

  @override
  bool get isAuth => _token != null;

  @override
  Stream<AppThemeMode> get themeModeStream => _themeController.stream;

  @override
  AppThemeMode get themeMode => _themeMode;

  @override
  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    _themeController.add(mode);
    _storage.saveBool(_keyDarkMode, mode == AppThemeMode.dark);
  }

  @override
  Stream<Locale> get localeStream => _localeController.stream;

  @override
  Locale get locale => _locale;

  @override
  void setLocale(Locale locale) {
    _locale = Locale(locale.languageCode);
    _localeController.add(_locale);
    _storage.saveString(_keyLocale, _locale.languageCode);
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
    _themeController.close();
    _localeController.close();
  }
}
