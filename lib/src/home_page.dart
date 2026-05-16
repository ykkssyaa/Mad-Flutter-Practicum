import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/repository/settings_repository.dart';
import '../domain/model/app_theme_mode.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsRepository settings = context.read<SettingsRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mad Flutter Practicum'),
        actions: [
          PopupMenuButton<AppThemeMode>(
            onSelected: settings.setThemeMode,
            itemBuilder: (context) => const [
              PopupMenuItem(value: AppThemeMode.light, child: Text('Light')),
              PopupMenuItem(value: AppThemeMode.dark, child: Text('Dark')),
              PopupMenuItem(value: AppThemeMode.system, child: Text('System')),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mad Flutter Practicum',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unified Root Application',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            StreamBuilder<bool>(
              stream: settings.isAuthStream,
              initialData: settings.isAuth,
              builder: (context, snapshot) {
                final bool isAuth = snapshot.data ?? settings.isAuth;
                return ElevatedButton(
                  onPressed: () async {
                    if (isAuth) {
                      await settings.setToken(null);
                    } else {
                      await settings.setToken('token');
                    }
                  },
                  child: Text(isAuth ? 'Logout' : 'Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

