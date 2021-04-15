import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lyric_audio/lib/Lyrics/lyric.dart';
import 'package:lyric_audio/lib/Lyrics/lyric_controller.dart';
import 'package:lyric_audio/lib/Lyrics/lyric_widget.dart';
import 'package:provider/provider.dart';

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
  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    var audioPlayer = Provider.of<AudioPlayer>(context);
    audioPlayer.play(widget.audioPath, isLocal: false);
    return Container(
      height: 250,
      child: Material(
        color: Colors.redAccent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            widget.play
                ? Expanded(
                    child: LyricWidget(
                      size: Size(double.infinity, double.infinity),
                      lyrics: widget.lyrics,
                      controller: controller,
                      currLyricStyle: TextStyle(color: Colors.white),
                      lyricStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  )
                : Text("No Lyric"),
            Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(3),
                    onTap: () async {
                      setState(() {
                        isPlay = !isPlay;
                      });
                      try {
                        isPlay ? await audioPlayer.resume() : await audioPlayer.pause();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 5),
                      child: Icon(
                        isPlay ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<Duration>(
                    initialData: duration,
                    stream: audioPlayer.onDurationChanged,
                    builder: (_, durationSnap) {
                      duration = durationSnap.data;
                      return StreamBuilder<Duration>(
                          initialData: Duration(),
                          stream: audioPlayer.onAudioPositionChanged,
                          builder: (_, snap) {
                            controller.progress = snap.data;
                            return Expanded(
                              child: Slider(
                                activeColor: Colors.white,
                                value: snap.data.inMilliseconds.toDouble() >
                                        duration.inMilliseconds.toDouble()
                                    ? 0.0
                                    : snap.data.inMilliseconds.toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChangeEnd: (d) {
                                  if (duration > snap.data) {
                                    audioPlayer.seek(
                                        Duration(milliseconds: d.toInt()));
                                  }
                                },
                                onChanged: (d) {},
                              ),
                            );
                          });
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
