import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/screens/home_page.dart';
import 'package:learning_english/until/constants.dart';
import 'package:provider/provider.dart';

import 'bloc/player_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Firestore.instance.settings(persistenceEnabled: true);
    return MultiProvider(
      providers: [
        Provider<AudioPlayer>(
          create: (context) => AudioPlayer(mode: PlayerMode.MEDIA_PLAYER),
        )
      ],
      child: BlocProvider<PlayerBloc>(
        create: (context) => PlayerBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Constants.primaryColor,
              accentColor: Colors.lightBlueAccent),
          home: HomePage(),
        ),
      ),
    );
  }
}
