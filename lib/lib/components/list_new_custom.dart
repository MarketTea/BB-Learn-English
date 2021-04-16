import 'package:flutter/material.dart';
import 'package:lyric_audio/lib/animation/PageAnimation.dart';
import 'package:lyric_audio/lib/models/artice_new.dart';
import 'package:lyric_audio/lib/screens/new_detail_page.dart';

Widget customListTitle(NewsArticle article, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(PageAnimation(child: NewDetailPage(article: article)));
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3.0)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: (article.urlToImage == null)
                      ? AssetImage('assets/listening.png')
                      : NetworkImage(article.urlToImage),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              article.source.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            article.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          )
        ],
      ),
    ),
  );
}
