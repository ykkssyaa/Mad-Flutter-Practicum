import '../../data/datasource/local_storage.dart';
import '../../domain/repository/settings_repository.dart';
import '../../domain/model/app_theme_mode.dart';
import 'dart:async';

/// Адаптированная реализация SettingsRepository для существующей data-слоя.
class SettingsRepositoryImpl implements SettingsRepository {
  static const _keyDarkMode = 'settings_dark_mode_v1';
  final LocalStorage _storage;

  final StreamController<bool> _isAuthController = StreamController<bool>.broadcast();
  final StreamController<AppThemeMode> _themeController = StreamController<AppThemeMode>.broadcast();

  String? _token;
  AppThemeMode _themeMode = AppThemeMode.system;

  SettingsRepositoryImpl({LocalStorage? storage}) : _storage = storage ?? LocalStorage();

  @override
  Future<void> initAsyncData() async {
    final bool? dark = await _storage.readBool(_keyDarkMode);
    _themeMode = (dark == null) ? AppThemeMode.system : (dark ? AppThemeMode.dark : AppThemeMode.light);
    _themeController.add(_themeMode);
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
  Future<String?> getToken() async => _token;

  @override
  Future<void> setToken(String? token) async {
    _token = token;
    _isAuthController.add(isAuth);
  }

  void dispose() {
    _isAuthController.close();
    _themeController.close();
  }
}
