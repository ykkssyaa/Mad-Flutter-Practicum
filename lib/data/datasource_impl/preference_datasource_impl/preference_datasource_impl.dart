import 'package:shared_preferences/shared_preferences.dart';
import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';

class PreferenceDatasourceImpl implements PreferenceDatasource {
  static const _keyTheme = 'pref_theme_mode_v1';
  static const _keyToken = 'pref_token_v1';

  AppThemeMode _themeMode = AppThemeMode.system;

  @override
  AppThemeMode get themeMode => _themeMode;

  @override
  void setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode.name);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  @override
  Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_keyToken);
    } else {
      await prefs.setString(_keyToken, token);
    }
  }
}

