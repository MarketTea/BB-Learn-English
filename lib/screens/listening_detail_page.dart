import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:learning_english/bloc/player_bloc.dart';
import 'package:learning_english/bloc/player_state.dart';
import 'package:learning_english/components/player.dart';
import 'package:learning_english/until/custom_dialog_box.dart';
import 'package:provider/provider.dart';

class ListeningDetail extends StatefulWidget {
  @override
  _ListeningDetailState createState() => _ListeningDetailState();
}

class _ListeningDetailState extends State<ListeningDetail> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_input_component_outlined),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: "Custom Dialog Demo",
                      descriptions:
                          "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                      text: "Yes",
                    );
                  });
            },
          ),
          IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: PopupMenuButton(
              onSelected: (newValue) {
                setState(() {
                  value = newValue;
                  if (value == 0) {
                    print("Click to: " + value.toString());
                  } else if (value == 1) {
                    print("Click to: " + value.toString());
                  } else if (value == 2) {
                    share('https://flutter.dev/',
                        'This is demo share in flutter');
                  }
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.playlist_add, color: Colors.black45),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text('Add to play list'),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.download_rounded, color: Colors.black45),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text('Download'),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Colors.black45),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text('Share'),
                      ),
                    ],
                  ),
                )
              ],
              child: Icon(Icons.more_vert),
            ),
          )
        ],
      ),
      body: Provider<AudioPlayer>(
        create: (_) => AudioPlayer(playerId: "myplayer"),
        child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (cxt, state) {
            // state is new state updated
            print(state);
            if (state is PlayerLoading) {
              return Player(false);
            }
            if (state is PlayerReadyState) {
              return Player(true,
                  audioPath: state.audioPath, lyrics: state.lyrics);
            }
            return Player(
              false,
            );
          },
        ),
      ),
    );
  }
}

Future<void> share(dynamic link, String title) async {
  await FlutterShare.share(
      title: 'BB Learn English',
      text: title,
      linkUrl: link,
      chooserTitle: 'Where you want to share');
}
