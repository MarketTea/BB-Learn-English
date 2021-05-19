import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:learning_english/animation/PageAnimation.dart';
import 'package:learning_english/components/learn_item.dart';
import 'package:learning_english/components/news.dart';
import 'package:learning_english/screens/setting_page.dart';
import 'package:learning_english/screens/video_page.dart';
import 'package:learning_english/until/constants.dart';

import 'grammar_page.dart';
import 'news_page.dart';
import 'recorder_page.dart';
import 'listening_page.dart';

class HomePage extends StatelessWidget {
  final learns = [
    {
      "src": "assets/onbarad1.png",
      "route": AudioRecorderPage(),
      "title": "Audio Recorder"
    },
    {
      "src": "assets/onbarad2.png",
      "route": Grammar(),
      "title": "Grammar and Exercise"
    },
    {"src": "assets/listening.png", "route": Listening(), "title": "Listening"}
  ];

  Drawer _buildDrawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/564x/49/fb/60/49fb60486d4c91217404bbe54e0f3695.jpg"),
                  ),
                  Text('Market Tea',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Mobile Developer',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            decoration: BoxDecoration(color: Constants.primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Photos'),
            onTap: () {
              print('Click photos');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(PageAnimation(child: Setting()));
              print('Click settings');
            },
          ),
          Divider(
            color: Colors.black45,
            indent: 16.0,
          ),
          ListTile(
            title: Text('About us'),
          ),
          ListTile(
            title: Text('Privacy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          elevation: 0,
        ),
        drawer: _buildDrawer(context),
        body: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 20),
                width: width,
                height: height / 3.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/png/appbar2.png",
                        ),
                        fit: BoxFit.fill)),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 10),
                      title: Text(
                        "Learn English Language",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )
                  ],
                )),
            Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: (height / 3) - 70),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                    ),
                    items: learns.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return LearnItem(
                            onPress: () {},
                            detail: i,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            News(
                              icon: Icon(
                                Icons.video_collection,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(PageAnimation(child: VideoPage()));
                              },
                              text: Text("Videos"),
                            ),
                            News(
                              icon: Icon(
                                Icons.collections_bookmark,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {},
                              text: Text("Book Mark"),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            News(
                              icon: Icon(
                                Icons.featured_play_list_rounded,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {},
                              text: Text("Programs"),
                            ),
                            News(
                              icon: Icon(
                                Icons.fiber_new,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(PageAnimation(child: NewsPage()));
                              },
                              text: Text("News"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
