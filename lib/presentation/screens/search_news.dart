import 'package:flutter/material.dart';
import 'package:newsapp/presentation/components/article_card.dart';
import 'package:newsapp/presentation/components/search_text_field.dart';
import 'package:newsapp/provider/news_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = "/search-news";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SearchTextField(
              onSubmitted: (query) async {
                await context.read<NewsProvider>().getArticlesFromQuery(query);
              },
              onChanged: (query) async {
                debugPrint("Current value is: ${query}");
                if (query.length < 3 && query.length % 2 == 0) {
                  context.read<NewsProvider>().clearSearchQuery();
                } else if (query.length == 0) {
                  await context
                      .read<NewsProvider>()
                      .getArticlesFromQuery(query);
                }
              },
            ),
            SizedBox(height: 20),
            Consumer<NewsProvider>(builder: (context, newsprovider, _) {
              return Column(
                children: [
                  if (newsprovider.loadingState) LinearProgressIndicator(),
                  ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      shrinkWrap: true,
                      itemCount: newsprovider.articlesListFromSearch.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ArticleCard(
                          article: newsprovider.articlesListFromSearch[index],
                        );
                      }),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
