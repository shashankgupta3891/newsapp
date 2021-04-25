import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/colors.dart';
import 'package:newsapp/core/http_client/http_client.dart';

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
  Widget build(BuildContext context) {
    _valueChanged(a) {
      print(a);
      widget.c.setCountry(a);
      print(widget.c.fetchCountryName());
      setState(() {});
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
      body: SingleChildScrollView(
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
                        value: _chosenValue,
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                        items: <String>['Newest', 'Popular', 'Oldest']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          "Newest",
                          style: TextStyle(
                              // color: Colors.black,
                              // fontSize: 16,
                              ),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 5),
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return ArticleCard();
                })
          ],
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

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.35,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10.0,
            spreadRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NewsSource",
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryColor2,
                    ),
                  ),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      height: 1.2,
                      // fontSize: 12,
                      // fontWeight: FontWeight.bold,
                      // color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    "10 min ago",
                    style: TextStyle(
                      // height: 1.2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.30,
              ),
              // width:
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                    "https://images.pexels.com/photos/2538122/pexels-photo-2538122.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                    fit: BoxFit.cover),
              ),
            )
          ],
        ),
      ),
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
        suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      ),
      onTap: () {},
      onChanged: (value) async {},
    );
  }
}
