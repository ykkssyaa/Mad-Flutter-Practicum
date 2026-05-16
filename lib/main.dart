import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/repository/settings_repository_impl.dart';
import 'domain/repository/settings_repository.dart';
import 'data/repository_impl/currency_repository_impl.dart';
import 'data/repository_impl/news_repository_impl.dart';
import 'domain/repository/currency_repository.dart';
import 'domain/repository/news_repository.dart';
import 'app/home.dart' as app_home;
import 'src/home_page.dart' as src_home;
import 'domain/model/app_theme_mode.dart';

void main() {
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
          return MaterialApp(
            title: 'Mad Flutter Practicum - Unified',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode == AppThemeMode.dark
                ? ThemeMode.dark
                : themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.system,
            home: StreamBuilder<bool>(
              stream: _settingsRepository.isAuthStream,
              initialData: _settingsRepository.isAuth,
              builder: (context, snapshot) {
                final isAuth = snapshot.data ?? false;
                return isAuth ? const app_home.HomePage() : const src_home.HomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
