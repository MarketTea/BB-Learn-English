import 'dart:ffi';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learning_english/Lyrics/lyric.dart';
import 'package:learning_english/Lyrics/lyric_controller.dart';
import 'package:learning_english/Lyrics/lyric_widget.dart';
import 'package:learning_english/animation/PageAnimation.dart';
import 'package:learning_english/bloc/player_bloc.dart';
import 'package:learning_english/bloc/player_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/screens/listening_detail_page.dart';
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
  IconData btnSpeed = Icons.exposure_zero; // the main state of the play button
  final List<double> valueSpeed = [0, 1.0, 2.0];

  AudioPlayer _audioPlayer;
  AudioCache audioCache = AudioCache();

  @override
  void dispose() {
    super.dispose();

    _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    _audioPlayer = Provider.of<AudioPlayer>(context);
    print('NEED_CONTROLLER: ' + Constants.formatDuration(controller.progress));
    print("------------------NEED_SPEED:----------------- " + valueSpeed[0].toString());
    print("------------------NEED_SPEED:----------------- " + valueSpeed[1].toString());
    print("------------------NEED_SPEED:----------------- " + valueSpeed[2].toString());
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
            Container(
              decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  )),
              child: Column(
                children: <Widget>[
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
                            style: TextStyle(color: Colors.white),
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
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.grey,
                                      value: snap.data.inMilliseconds
                                                  .toDouble() >
                                              duration.inMilliseconds.toDouble()
                                          ? 0.0
                                          : snap.data.inMilliseconds.toDouble(),
                                      max: duration.inMilliseconds.toDouble(),
                                      onChangeEnd: (d) {
                                        if (duration > snap.data) {
                                          _audioPlayer.seek(Duration(
                                              milliseconds: d.toInt()));
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
                            style: TextStyle(color: Colors.white),
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
                            color: Colors.white,
                            onPressed: () {
                              if (playing) {
                                _audioPlayer.pause();
                                setState(() {
                                  btnPlay = Icons.play_arrow;
                                  playing = false;
                                });
                              }
                              _showSheet(context);
                            }),
                        IconButton(
                            icon: Icon(Icons.replay_5),
                            iconSize: 30.0,
                            color: Colors.white,
                            onPressed: () {
                              if (!playing) {
                                print('Nothing');
                              } else {
                                replay5Seconds();
                              }
                            }),
                        IconButton(
                            icon: Icon(btnPlay),
                            iconSize: 50.0,
                            color: Colors.white,
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
                            icon: Icon(Icons.forward_10),
                            iconSize: 30.0,
                            color: Colors.white,
                            onPressed: () {
                              if (!playing) {
                                print('Nothing');
                              } else {
                                forward10Seconds();
                              }
                            }),
                        IconButton(
                            icon: Icon(btnSpeed),
                            iconSize: 30.0,
                            color: Colors.white,
                            onPressed: () {
                              // ignore: unrelated_type_equality_checks
                              if (valueSpeed[0] == 0.0) {
                                btnSpeed = Icons.exposure_zero;
                                _audioPlayer.setPlaybackRate(playbackRate: 0.5);
                              // ignore: unrelated_type_equality_checks
                              } else if (valueSpeed[1] == 1.0) {
                                btnSpeed = Icons.one_k;
                                _audioPlayer.setPlaybackRate(playbackRate: 1.0);
                              // ignore: unrelated_type_equality_checks
                              } else if (valueSpeed[2] == 2.0) {
                                btnSpeed = Icons.two_k;
                                _audioPlayer.setPlaybackRate(playbackRate: 2.0);
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.64,
        minChildSize: 0.2,
        maxChildSize: 1,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            color: Colors.white,
            child: FutureBuilder(
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
                      controller: scrollController,
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
                                    child: Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 50.0,
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      listening[index]
                                                          .data['image']),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  listening[index]
                                                      .data['title'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 6.0),
                                                Text(
                                                    listening[index]
                                                        .data['dateTimer'],
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 10.0))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return Container();
              },
            ),
            // child: ListView.builder(
            //   controller: scrollController,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text('Item $index'),
            //     );
            //   },
            //   itemCount: 20,
            // ),
          );
        },
      ),
    );
  }

  Future replay5Seconds() async {
    var secondsNow = Constants.formatDuration(controller.progress);
    var secondsReplay = controller.progress - Duration(seconds: 5);
    var formatSecondsReplay = Constants.formatDuration(secondsReplay);

    print("NEED_SECONDS_REPLAY:----------------- " + secondsNow.toString());
    print("NEED_SECONDS_REPLAY:------------ " + secondsReplay.toString());
    print("NEED_SECONDS_REPLAY:-------- " + formatSecondsReplay.toString());

    _audioPlayer.seek(secondsReplay);
    return secondsReplay;
  }

  Future forward10Seconds() async {
    var secondsForward = controller.progress + Duration(seconds: 10);
    print("NEED_SECONDS: " + secondsForward.toString());
    _audioPlayer.seek(secondsForward);
    var songLength = duration;
    if (secondsForward > songLength) {
      _audioPlayer.seek(controller.progress);
    }
    print("NEED_LENGTH: " + songLength.toString());
    return secondsForward;
  }
}
