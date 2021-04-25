import 'package:flutter/material.dart';
import 'package:newsapp/core/http_client/http_client.dart';
import 'package:newsapp/core/model/article_model.dart';

class NewsProvider extends ChangeNotifier {
  List<Article> _articlesList = [];
  List<Article> _articlesListFromSearch = [];

  bool _loadingState = false;

  List<SortType> _sortButtonItems = [
    SortType.publishedAt,
    SortType.popularity,
    SortType.relevancy,
  ];

  SortType _currentSortType = SortType.publishedAt;

  SortType get currentSortType => _currentSortType;

  List<SortType> get sortButtonItems => _sortButtonItems;

  List<Article> get articlesList => _articlesList;
  List<Article> get articlesListFromSearch => _articlesListFromSearch;

  bool get loadingState => _loadingState;

  void setCurrentSortType(String currentSort) async {
    switch (currentSort) {
      case "relevancy":
        _currentSortType = SortType.relevancy;
        break;
      case "popularity":
        _currentSortType = SortType.popularity;
        break;
      case "publishAt":
        _currentSortType = SortType.publishedAt;
        break;
      default:
        _currentSortType = SortType.publishedAt;
    }

    await getNewsArticlesFromApi();
  }

  void setDefaultSettingsAndGetRequest() async {
    _currentSortType = SortType.publishedAt;
    await getNewsArticlesFromApi();
  }

  Future<void> getNewsArticlesFromApi() async {
    _loadingState = true;
    notifyListeners();

    final Map _queryParameters = {
      "q": "india",
      "sortBy": _currentSortType.text,
    };

    var responce = await BaseApiClient.get(
        url: "/v2/everything", queryParameters: _queryParameters);
    try {
      if (responce["status"] == "ok") {
        _articlesList = (responce["articles"] as List)
            .map((e) => Article.fromJson(e))
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingState = false;
      notifyListeners();
    }

    print(_articlesList);
  }

  void clearSearchQuery() async {
    _articlesListFromSearch = [];
    notifyListeners();
  }

  Future<void> getArticlesFromQuery(String quary) async {
    _currentSortType = SortType.publishedAt;
    _loadingState = true;
    notifyListeners();

    final Map _queryParameters = {
      "q": quary,
      "sortBy": _currentSortType.text,
    };

    var responce = await BaseApiClient.get(
        url: "/v2/everything", queryParameters: _queryParameters);
    try {
      if (responce["status"] == "ok") {
        _articlesListFromSearch = (responce["articles"] as List)
            .map((e) => Article.fromJson(e))
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingState = false;
      notifyListeners();
    }

    print(_articlesList);
  }
}

enum SortType { relevancy, popularity, publishedAt }

extension ParseString on SortType {
  String get text {
    return toString().split('.').last;
  }

  String get displayText {
    switch (this) {
      case SortType.relevancy:
        return "Relevancy";
      case SortType.popularity:
        return "Popularity";
      case SortType.publishedAt:
        return "Publish At";
      default:
        return "Others";
    }
  }
}
