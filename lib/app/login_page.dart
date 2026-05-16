import 'dart:math' show Random, pi;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gen/l10n/app_localizations.dart';
import '../domain/repository/settings_repository.dart';
import 'utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsRepository>();
    final loc = AppLocalizations.of(context)!;
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rotating logo
                AnimatedBuilder(
                  animation: _controller,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: colors.blueDepression.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.currency_exchange,
                      size: 48,
                      color: colors.blueDepression,
                    ),
                  ),
                  builder: (BuildContext context, Widget? child) => Transform.rotate(angle: _controller.value * 2 * pi, child: child),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Вход в приложение',
                  style: fonts.regular16.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle / description
                Text(
                  'Войдите, чтобы просматривать актуальные курсы валют и новости.',
                  style: fonts.regular14.copyWith(color: colors.tin),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // Big login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => settings.setToken(_generateRandomToken()),
                    icon: Icon(Icons.login, color: colors.white),
                    label: Text(
                      loc.login,
                      style: fonts.regular16.copyWith(color: colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.blueDepression,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                      textStyle: fonts.regular16,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _generateRandomToken([int length = 32]) {
  const String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  final Random random = Random();

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}
