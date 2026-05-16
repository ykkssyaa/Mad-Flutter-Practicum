import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/app/gen/l10n/app_localizations.dart';

void main() {
  testWidgets('Localization shows Russian strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: Builder(builder: (context) {
          return Text(AppLocalizations.of(context)!.news);
        }),
      ),
    );

    expect(find.text('Новости'), findsOneWidget);
  });
}


