import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'data/repository_impl/settings_repository_impl.dart';
import 'domain/repository/settings_repository.dart';
import 'domain/repository/currency_repository.dart';
import 'domain/repository/news_repository.dart';
import 'data/repository_impl/currency_repository_impl.dart';
import 'data/repository_impl/news_repository_impl.dart';
import 'app/home.dart' as app_home;
import 'app/login_page.dart' as app_login;
import 'domain/model/app_theme_mode.dart';
import 'app/gen/l10n/app_localizations.dart';
import 'app/utils/theme/theme_data.dart';

void main() {
  // Initialize sqlite ffi for desktop platforms so sqflite works on Windows/Linux/Mac
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  late final SettingsRepositoryImpl _settingsRepository;

  @override
  void initState() {
    super.initState();
    _settingsRepository = SettingsRepositoryImpl();
    _settingsRepository.initAsyncData();
  }

  @override
  void dispose() {
    _settingsRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsRepository>.value(value: _settingsRepository),
        Provider<CurrencyRepository>(create: (_) => CurrencyRepositoryImpl()),
        Provider<NewsRepository>(create: (_) => NewsRepositoryImpl()),
      ],
      child: StreamBuilder<AppThemeMode>(
        stream: _settingsRepository.themeModeStream,
        initialData: _settingsRepository.themeMode,
        builder: (context, snapshot) {
          final themeMode = snapshot.data ?? AppThemeMode.system;
          return StreamBuilder<Locale>(
            stream: _settingsRepository.localeStream,
            initialData: _settingsRepository.locale,
            builder: (context, localeSnapshot) {
              final Locale locale = localeSnapshot.data ?? const Locale('ru');

              return MaterialApp(
                title: 'Mad Flutter Practicum - Unified',
                debugShowCheckedModeBanner: false,
                theme: ThemeData.light().appThemeData,
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  useMaterial3: true,
                  scaffoldBackgroundColor: const Color(0xFF121212),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Color(0xFF1E1E1E),
                    foregroundColor: Colors.white,
                  ),
                  popupMenuTheme: const PopupMenuThemeData(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.white),
                    bodyMedium: TextStyle(color: Colors.white),
                    bodySmall: TextStyle(color: Colors.white70),
                    titleLarge: TextStyle(color: Colors.white),
                    titleMedium: TextStyle(color: Colors.white),
                    titleSmall: TextStyle(color: Colors.white70),
                    labelLarge: TextStyle(color: Colors.white),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    backgroundColor: Color(0xFF1E1E1E),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white54,
                  ),
                ).appThemeData,
                themeMode: themeMode == AppThemeMode.dark
                    ? ThemeMode.dark
                    : themeMode == AppThemeMode.light
                        ? ThemeMode.light
                        : ThemeMode.system,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: StreamBuilder<bool>(
                  stream: _settingsRepository.isAuthStream,
                  initialData: _settingsRepository.isAuth,
                  builder: (context, snapshot) {
                    final isAuth = snapshot.data ?? false;
                    return isAuth ? const app_home.HomePage() : const app_login.LoginPage();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
