import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyric_audio/lib/playerbloc/player_bloc.dart';
import 'package:lyric_audio/lib/screens/App.dart';
import 'package:provider/provider.dart';

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
              primaryColor: Color.fromRGBO(245, 41, 40, 1),
              accentColor: Colors.redAccent),
          home: App(),
        ),
      ),
    );
  }
}
