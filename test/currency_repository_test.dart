import 'package:flutter_test/flutter_test.dart';
import 'package:mad_flutter_practicum/data/repository_impl/currency_repository_impl.dart';

void main() {
  test('CurrencyRepository returns sample list', () async {
    final repo = CurrencyRepositoryImpl();
    final list = await repo.getCurrencyList();
    expect(list, isNotEmpty);
    expect(list.first.symbol, 'USD');
  });
}

