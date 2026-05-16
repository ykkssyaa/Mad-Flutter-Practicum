import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mad_flutter_practicum/data/datasource/rest_api.dart';

void main() {
  test('RestApiClient parses JSON response', () async {
    final mockClient = MockClient((request) async {
      return http.Response(jsonEncode({'ok': true}), 200);
    });

    final api = RestApiClient(mockClient);
    final json = await api.getJson('https://example.test/');
    expect(json, isA<Map>());
    expect(json['ok'], isTrue);
  });
}

