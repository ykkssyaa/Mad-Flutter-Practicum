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

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          child: ElevatedButton(
            onPressed: () => settings.setToken(_generateRandomToken()),
            child: Text(
              loc.login,
              style: context.fonts.regular14,
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(angle: _controller.value * 2 * pi, child: child);
          },
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
