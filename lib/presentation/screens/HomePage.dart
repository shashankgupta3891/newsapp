import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/colors.dart';
import 'package:newsapp/core/http_client/api_repository.dart';
import 'package:newsapp/core/http_client/http_client.dart';
import 'package:newsapp/presentation/components/article_card.dart';
import 'package:newsapp/provider/news_provider.dart';
import 'package:provider/provider.dart';

import '../../data_repository/local/Countries.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.c}) : super(key: key);

  final Countries c;

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TextEditingController custom = TextEditingController();
  String _chosenValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<NewsProvider>().getNewsAccordingToCurrentParams());
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
                              child: Text(
                                "Choose Your Location",
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
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: widget.c.country.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        _valueChanged(index);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            widget.c.country[index],
                                            style:
                                                new TextStyle(fontSize: 16.0),
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
                  Text(
                    "Location",
                    style: TextStyle(fontSize: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 15,
                      ),
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
          await context.read<NewsProvider>().getNewsAccordingToCurrentParams();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SearchTextField(),
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
                  ));
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey[100].withOpacity(0.5),
        hintText: 'Search for news,topics...',
        hintStyle: TextStyle(fontSize: 14, color: Colors.blueGrey.shade400),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 0.00001, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 0.00001, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 0.00001, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        suffixIcon: Icon(Icons.search),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      ),
      onTap: () {},
      onChanged: (value) async {},
    );
  }
}
