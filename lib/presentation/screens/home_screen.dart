import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/presentation/components/article_card.dart';
import 'package:newsapp/presentation/components/search_text_field.dart';
import 'package:newsapp/presentation/screens/search_news.dart';
import 'package:newsapp/provider/news_provider.dart';
import 'package:provider/provider.dart';

import '../../data_repository/local/countries.dart';

class Countries {
  int SelectedCountry;
  Countries(int selected) {
    SelectedCountry = selected;
  }

  List<String> country = [
    "Nepal",
    "USA",
    "India",
    "Sri Lanka",
    "England",
    "Sweden",
    "Pacific Island"
  ];
  String fetchCountryName() {
    return country[SelectedCountry];
  }

  int currentCountry() {
    return SelectedCountry;
  }

  void setCountry(int selected) {
    SelectedCountry = selected;
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  final Countries c = Countries(2);

  // final String title;

  final List<String> country = [
    "Nepal",
    "USA",
    "India",
    "Sri Lanka",
    "England",
    "Sweden",
    "Pacific Island"
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController custom = TextEditingController();
  String _chosenValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<NewsProvider>().getNewsArticlesFromApi());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Provider.of<NewsProvider>(context, listen: false)
    //     .getNewsAccordingToCurrentParams();
  }

  @override
  Widget build(BuildContext context) {
    _valueChanged(a) {
      print(a);
      widget.c.setCountry(a);
      print(widget.c.fetchCountryName());
      // setState(() {});
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("MyNews"),
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                    context: context,
                    builder: (BuildContext context) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Choose Your Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              indent: 10,
                              endIndent: 10,
                              thickness: 2,
                            ),
                            Flexible(
                              child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: widget.c.country.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        _valueChanged(index);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            widget.c.country[index],
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Radio(
                                            value: index,
                                            groupValue:
                                                widget.c.currentCountry(),
                                            onChanged: _valueChanged,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Location", style: TextStyle(fontSize: 14)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on, size: 15),
                      Text(
                        widget.c.fetchCountryName(),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<NewsProvider>().getNewsArticlesFromApi();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SearchTextField(
                readOnly: true,
                onTap: () {
                  Navigator.pushNamed(context, SearchScreen.routeName);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Top Headlines",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Row(
                    children: [
                      Text("Sort: "),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: context
                              .watch<NewsProvider>()
                              .currentSortType
                              .text,
                          style: TextStyle(color: Colors.black),
                          items: context
                              .read<NewsProvider>()
                              .sortButtonItems
                              .map<DropdownMenuItem<String>>((SortType value) {
                            return DropdownMenuItem<String>(
                              value: value.text,
                              child: Text(value.displayText),
                            );
                          }).toList(),
                          hint: Text(
                            context
                                .read<NewsProvider>()
                                .currentSortType
                                .displayText,
                            style: TextStyle(
                                // color: Colors.black,
                                // fontSize: 16,
                                ),
                          ),
                          onChanged: (String value) {
                            print(value);
                            context
                                .read<NewsProvider>()
                                .setCurrentSortType(value);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
                        itemCount: newsprovider.articlesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ArticleCard(
                            article: newsprovider.articlesList[index],
                          );
                        }),
                  ],
                );
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.sort),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Filter By Sources",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                              activeColor: Colors.blue[300],
                              dense: true,
                              //font change
                              title: new Text(
                                "News Source ${index + 1}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5),
                              ),
                              value: true,
                              onChanged: (bool val) {});
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
