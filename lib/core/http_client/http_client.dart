import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class BaseApiClient {
  //https://blog.usejournal.com/flutter-http-requests-with-dio-rxdart-and-bloc-da325ca5fe33

  static final String _baseUrl = "https://newsapi.org/v2/";

  static final Map _queryParameters = {
    "apiKey": "edcb41c5a0dd4c9aaf4acff2926c63dd",
  };

  static final http.Client _client = http.Client();

  static Future<http.Response> get(String url, Map queryParameters) async {
    try {
      final http.Response response = await _client.get(
          Uri.https(_baseUrl, url, {...queryParameters, ..._queryParameters}));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
