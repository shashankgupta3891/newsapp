import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/colors.dart';
import 'package:newsapp/core/model/article_model.dart';
import 'package:newsapp/core/utils/utils.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  const ArticleCard({
    Key key,
    @required this.article,
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
      child: InkWell(
        onTap: () {
          // Navigator.push(context, Material)
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article?.source?.name ?? "NewsSource",
                      style: TextStyle(
                        height: 1.2,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: primaryColor2,
                      ),
                    ),
                    Text(
                      article.description ??
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        height: 1.2,
                      ),
                    ),
                    Text(
                      convertToAgo(article.publishedAt),
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
                      article.urlToImage ??
                          "https://images.pexels.com/photos/2538122/pexels-photo-2538122.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      fit: BoxFit.cover),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
