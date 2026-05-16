import 'dart:convert';
import 'package:http/http.dart' as http;

class RestApiClient {
  final http.Client _client;

  RestApiClient([http.Client? client]) : _client = client ?? http.Client();

  Future<dynamic> getJson(String url) async {
    final resp = await _client.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Network error: ${resp.statusCode}');
    }
    return json.decode(resp.body);
  }
}

