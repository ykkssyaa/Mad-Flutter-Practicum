export 'package:flutter/material.dart';
export 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Re-exports from lab_6 structure to keep compatibility with package imports
export 'currency_detail/currency_detail_page.dart';
export 'currency_list/currency_list_page.dart';
export 'gen/gen.dart';
export 'news_list/news_list_page.dart';
export 'profile/profile_page.dart';
export 'utils/utils.dart';
export 'constants.dart';
export 'home.dart';
export 'splash_page.dart';
export 'login_page.dart';
import '../shared/app_state.dart';
import 'gen/l10n/app_localizations.dart';
import 'home.dart';
import '../data/repository_impl/currency_repository_impl.dart';
import '../data/repository_impl/news_repository_impl.dart';
import '../domain/repository/settings_repository_impl.dart';
import '../domain/repository/settings_repository.dart';
import '../domain/repository/currency_repository.dart';
import '../domain/repository/news_repository.dart';
import 'utils/theme/theme_data.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        Provider<CurrencyRepository>(create: (_) => CurrencyRepositoryImpl()),
        Provider<NewsRepository>(create: (_) => NewsRepositoryImpl()),
        // Provide a simple SettingsRepositoryImpl so widgets that read it in tests can function.
        Provider<SettingsRepository>(create: (_) => SettingsRepositoryImpl()),
      ],
      child: Builder(builder: (context) {
        final state = context.watch<AppState>();
        return MaterialApp(
          title: 'Mad Flutter Practicum',
          debugShowCheckedModeBanner: false,
          theme: state.isDark ? ThemeData.dark().appThemeData : ThemeData.light().appThemeData,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        );
      }),
    );
  }
}
