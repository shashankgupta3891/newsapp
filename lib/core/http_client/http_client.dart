import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class BaseApiClient {
  static final String _baseUrl = "newsapi.org";
  static final String _urlPath = "/v2";

  static final Map _queryParameters = {
    "apiKey": "edcb41c5a0dd4c9aaf4acff2926c63dd",
    "pageSize": "20"
  };

  static final http.Client _client = http.Client();

  static Future<dynamic> get({String url, Map queryParameters}) async {
    try {
      final requestUrl =
          Uri.https(_baseUrl, url, {...queryParameters, ..._queryParameters});
      debugPrint(requestUrl.toString());
      final http.Response response = await _client.get(requestUrl);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"Error Found"};
      }
    } catch (e) {
      rethrow;
    }
  }
}
