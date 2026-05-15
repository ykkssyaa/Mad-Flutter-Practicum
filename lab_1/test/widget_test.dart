import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/main.dart';

void main() {
  testWidgets('lab 1 app shows currency list screen', (WidgetTester tester) async {
	await tester.pumpWidget(const App());
	await tester.pump();

	expect(find.text('Курс Валют'), findsOneWidget);
	expect(find.byType(TextField), findsOneWidget);
	expect(find.text('Австралийский доллар'), findsNWidgets(5));
  });
}
