import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:learning_english/Lyrics/lyric.dart';
import 'package:learning_english/Lyrics/lyric_controller.dart';
import 'package:learning_english/Lyrics/lyric_widget.dart';
import 'package:learning_english/until/constants.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Player extends StatefulWidget {
  final bool play;
  String audioPath;
  List<Lyric> lyrics;

  Player(this.play, {this.audioPath, this.lyrics});

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  Duration duration = Duration(milliseconds: 0);
  LyricController controller = LyricController();
  bool playing = false; // at the beginning, not playing any song
  IconData btnPlay = Icons.play_arrow; // the main state of the play button

  AudioPlayer _audioPlayer;

  @override
  void dispose() {
    super.dispose();

    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    _audioPlayer = Provider.of<AudioPlayer>(context);
    //_audioPlayer.play(widget.audioPath, isLocal: false);
    return Container(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            widget.play
                ? Expanded(
                    child: LyricWidget(
                      size: Size(double.infinity, double.infinity),
                      lyrics: widget.lyrics,
                      controller: controller,
                      currLyricStyle: TextStyle(color: Colors.blue),
                      lyricStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                  )
                : Text("No Lyric"),
            Row(
              children: <Widget>[
                SizedBox(width: 8.0),
                StreamBuilder<Duration>(
                  initialData: Duration(),
                  stream: _audioPlayer.onDurationChanged,
                  builder: (_, snapshot) {
                    duration = snapshot.data;
                    return Text(
                      controller.progress == null
                          ? "--:--"
                          : Constants.formatDuration(controller.progress),
                      style: TextStyle(color: Colors.blue),
                    );
                  },
                ),
                StreamBuilder<Duration>(
                    initialData: duration,
                    stream: _audioPlayer.onDurationChanged,
                    builder: (_, durationSnap) {
                      duration = durationSnap.data;
                      return StreamBuilder<Duration>(
                          initialData: Duration(),
                          stream: _audioPlayer.onAudioPositionChanged,
                          builder: (_, snap) {
                            controller.progress = snap.data;
                            return Expanded(
                              child: Slider(
                                activeColor: Colors.blueAccent,
                                value: snap.data.inMilliseconds.toDouble() >
                                        duration.inMilliseconds.toDouble()
                                    ? 0.0
                                    : snap.data.inMilliseconds.toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChangeEnd: (d) {
                                  if (duration > snap.data) {
                                    _audioPlayer.seek(
                                        Duration(milliseconds: d.toInt()));
                                  }
                                },
                                onChanged: (d) {},
                              ),
                            );
                          });
                    }),
                StreamBuilder<Duration>(
                  initialData: duration,
                  stream: _audioPlayer.onAudioPositionChanged,
                  builder: (_, snap) {
                    controller.progress = snap.data;
                    return Text(
                      duration == null
                          ? "--:--"
                          : Constants.formatDuration(duration),
                      style: TextStyle(color: Colors.blue),
                    );
                  },
                ),
                SizedBox(width: 8.0),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.format_list_bulleted),
                      iconSize: 30.0,
                      color: Colors.blue,
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.settings_backup_restore),
                      iconSize: 30.0,
                      color: Colors.blue,
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(btnPlay),
                      iconSize: 50.0,
                      color: Colors.blue,
                      onPressed: () {
                        if (!playing) {
                          _audioPlayer.play(widget.audioPath, isLocal: false);
                          setState(() {
                            btnPlay = Icons.pause;
                            playing = true;
                          });
                        } else {
                          _audioPlayer.pause();
                          setState(() {
                            btnPlay = Icons.play_arrow;
                            playing = false;
                          });
                        }
                      }),
                  IconButton(
                      icon: Icon(Icons.update),
                      iconSize: 30.0,
                      color: Colors.blue,
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.repeat),
                      iconSize: 30.0,
                      color: Colors.blue,
                      onPressed: () {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
