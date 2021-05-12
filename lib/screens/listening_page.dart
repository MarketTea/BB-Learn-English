import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/animation/PageAnimation.dart';
import 'package:learning_english/bloc/player_bloc.dart';
import 'package:learning_english/bloc/player_event.dart';

import 'listening_detail_page.dart';

class Listening extends StatefulWidget {
  @override
  _ListenState createState() => _ListenState();
}

class _ListenState extends State<Listening> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listening"),
        titleSpacing: 0,
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection("listening").getDocuments(),
        builder: (cxt, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snap.connectionState == ConnectionState.done) {
            var data = snap.data as QuerySnapshot;
            if (data != null) {
              var listening = data.documents;
              return ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: listening.length,
                itemBuilder: (cxt, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 5),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          Navigator.of(context)
                              .push(PageAnimation(child: ListeningDetail()));
                          context.bloc<PlayerBloc>().add(PlayEvent(
                              audioUrl: listening[index].data['audio'],
                              lrcUrl: listening[index].data['lrc']));
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 200.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            listening[index].data['image']),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Container(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    listening[index].data['title'],
                                    style: TextStyle(color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.visibility_sharp,
                                              color: Colors.black38),
                                          SizedBox(width: 4),
                                          Text(
                                            listening[index]
                                                    .data['viewer']
                                                    .toString() ??
                                                "Empty",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 16),
                                      Row(
                                        children: [
                                          Icon(Icons.favorite_outlined,
                                              color: Colors.black38),
                                          SizedBox(width: 4),
                                          Text(
                                            listening[index]
                                                    .data['dowload']
                                                    .toString() ??
                                                "Empty",
                                            style: TextStyle(
                                                color: Colors.black38),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("Empty"),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
