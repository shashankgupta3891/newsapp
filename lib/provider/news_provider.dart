import 'package:flutter/material.dart';
import 'package:newsapp/core/http_client/http_client.dart';
import 'package:newsapp/core/model/article_model.dart';

class NewsProvider extends ChangeNotifier {
  List<Article> _articlesList = [];

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

    await getNewsAccordingToCurrentParams();
  }

  void setDefaultSettingsAndGetRequest() async {
    _currentSortType = SortType.popularity;
    await getNewsAccordingToCurrentParams();
  }

  Future<void> getNewsAccordingToCurrentParams() async {
    _loadingState = true;
    notifyListeners();

    final Map _queryParameters = {
      "q": "india",
      "sortBy": _currentSortType.text,
      "pageSize": "20"
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

  // int get statusColor {
  //   switch (this) {
  //     case OrderStatus.draft:
  //       return 0x80000000;

  //     case OrderStatus.confirmed:
  //       return 0xffFABC02;
  //     case OrderStatus.accepted:
  //       return 0xff0865B6;
  //     case OrderStatus.ready:
  //       return 0xff54b324;
  //     case OrderStatus.delivered:
  //       return 0xff54b324;
  //     case OrderStatus.cancelled:
  //       return 0xfff63d2e;
  //     default:
  //       return 0xffbd574e;
  //   }
  // }
}
