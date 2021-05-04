import 'package:flutter/material.dart';
import 'package:learning_english/components/list_new_custom.dart';
import 'package:learning_english/models/artice_new.dart';
import 'package:learning_english/services/api_service.dart';
import 'package:learning_english/until/constants.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  APIService client = APIService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News", style: TextStyle(color: Colors.white)),
        backgroundColor: Constants.primaryColor,
      ),
      body: FutureBuilder(
          future: client.fetchTopHeadLines(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<NewsArticle> articles = snapshot.data;
              return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return customListTitle(articles[index], context);
                  });
            } else if (snapshot.hasError) {
              return Container(
                child: Center(child: Text('Not Found Data')),
              );
            } else {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          }),
    );
  }
}
