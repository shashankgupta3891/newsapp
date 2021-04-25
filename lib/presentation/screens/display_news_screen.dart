import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/colors.dart';
import 'package:newsapp/core/model/article_model.dart';
import 'package:newsapp/core/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayNewsScreen extends StatelessWidget {
  static String routeName = "/display-news-screen";

  const DisplayNewsScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Article args = ModalRoute.of(context).settings.arguments as Article;
    Future<void> _launchURL(String url) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.width / 2),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.darken),
                      image: NetworkImage(args.urlToImage ??
                          "https://images.pexels.com/photos/2156881/pexels-photo-2156881.jpeg?auto=compress&cs=tinysrgb&h=650&w=940"),
                      fit: BoxFit.fitWidth)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      args.title ??
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          height: 1.2, color: Colors.white, fontSize: 23),
                    ),
                  ),
                  // Text(args.title),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    args?.source?.name ?? "NewsSource",
                    style: TextStyle(
                      height: 1.2,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      dateAtTime(args.publishedAt),
                      style: TextStyle(
                        // height: 1.2,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Text(args.content),
                  TextButton(
                      onPressed: () async {
                        await _launchURL(args.url);
                      },
                      child: Text("See full story")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
