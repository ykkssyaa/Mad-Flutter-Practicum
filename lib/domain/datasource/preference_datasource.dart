import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

abstract interface class PreferenceDatasource {
  AppThemeMode get themeMode;

  void setThemeMode(AppThemeMode mode);

  Future<String?> getToken();

  Future<void> setToken(String? token);
}

