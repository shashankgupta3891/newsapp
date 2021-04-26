import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/core/constants/key/key.dart';

abstract class BaseApiClient {
  static final String _baseUrl = "newsapi.org";
  static final String _urlPath = "/v2/everything";

  static final Map _queryParameters = {"apiKey": kApiKey, "pageSize": "20"};

  static final http.Client _client = http.Client();

  static Future<dynamic> get({Map queryParameters}) async {
    try {
      final requestUrl = Uri.https(
          _baseUrl, _urlPath, {...queryParameters, ..._queryParameters});
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
