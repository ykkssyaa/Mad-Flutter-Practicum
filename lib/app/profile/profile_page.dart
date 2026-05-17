import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';

part 'theme_mode_selector_bs.dart';
part 'locale_selector_bs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ValueNotifier<AppThemeMode> _themeModeNotifier = ValueNotifier(_settingsRepository.themeMode);
  late final ValueNotifier<Locale> _localeNotifier = ValueNotifier(_settingsRepository.locale);

  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    _localeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final AppLocalizations loc = context.loc;

    return Scaffold(
      appBar: AppBar(title: Text(loc.profile)),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Prominent theme selector card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: context.colors.cardColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final AppThemeMode current = _themeModeNotifier.value;
                    final AppThemeMode? newMode = await ThemeModeSelectorBottomSheet.show(context, current);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: context.colors.blueDepression.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.dark_mode,
                            size: 26,
                            color: context.colors.blueDepression,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ValueListenableBuilder<AppThemeMode>(
                            valueListenable: _themeModeNotifier,
                            builder: (context, mode, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.theme,
                                  style: fonts.regular16.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mode.titleOf(loc),
                                  style: fonts.regular14.copyWith(color: context.colors.tin),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: context.colors.platinumGranite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Language selector card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: context.colors.cardColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final Locale current = _localeNotifier.value;
                    final Locale? newLocale = await LocaleSelectorBottomSheet.show(context, current);
                    if (newLocale == null) return;

                    _localeNotifier.value = newLocale;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: context.colors.blueDepression.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.language,
                            size: 26,
                            color: context.colors.blueDepression,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ValueListenableBuilder<Locale>(
                            valueListenable: _localeNotifier,
                            builder: (context, locale, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.language,
                                  style: fonts.regular16.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  locale.titleOf(loc),
                                  style: fonts.regular14.copyWith(color: context.colors.tin),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: context.colors.platinumGranite,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Large full-width logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.read<SettingsRepository>().setToken(null),
                  icon: Icon(Icons.exit_to_app, color: context.colors.white),
                  label: Text(
                    loc.logout,
                    style: fonts.regular16.copyWith(color: context.colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    textStyle: fonts.regular16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
