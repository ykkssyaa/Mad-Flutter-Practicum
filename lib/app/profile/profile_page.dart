import 'package:mad_flutter_practicum/app/app.dart';
import 'package:mad_flutter_practicum/domain/domain.dart';

part 'theme_mode_selector_bs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ValueNotifier<AppThemeMode> _themeModeNotifier = ValueNotifier(_settingsRepository.themeMode);

  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _themeModeNotifier.dispose();
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
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder: (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.dark_mode),
                  title: child,
                  subtitle: Text(
                    mode.titleOf(loc),
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode = await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                );
              },
              child: Text(
                loc.theme,
                style: fonts.regular16,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () => context.read<SettingsRepository>().setToken(null),
                child: Text(
                  loc.logout,
                  style: fonts.regular14.copyWith(color: context.colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
