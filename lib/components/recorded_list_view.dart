import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class Records extends StatefulWidget {
  final List<String> records;

  const Records({
    Key key,
    this.records,
  }) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  int _totalTime;
  int _currentTime;
  double _percent = 0.0;
  int _selected = -1;
  bool isPlay = false;
  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.records.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          elevation: 5,
          child: ExpansionTile(
            title: Text(
              'Record ${widget.records.length - i}',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              _getTime(filePath: widget?.records?.elementAt(i)),
              style: TextStyle(color: Colors.black38),
            ),
            onExpansionChanged: ((newState) {
              if (newState) {
                setState(() {
                  _selected = i;
                });
              }
            }),
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      value: _selected == i ? _percent : 0,
                    ),
                    Row(
                      children: [
                        (isPlay)
                            ? _TouchIcon(
                                icon: Icons.pause,
                                onPressed: () {
                                  setState(() {
                                    isPlay = false;
                                  });
                                  advancedPlayer.pause();
                                })
                            : _TouchIcon(
                                icon: Icons.play_arrow,
                                onPressed: () {
                                  setState(() {
                                    isPlay = true;
                                  });
                                  advancedPlayer.play(
                                      widget.records.elementAt(i),
                                      isLocal: true);
                                  setState(() {});
                                  setState(() {
                                    _selected = i;
                                    _percent = 0.0;
                                  });
                                  advancedPlayer.onPlayerCompletion.listen((_) {
                                    setState(() {
                                      _percent = 0.0;
                                    });
                                  });
                                  advancedPlayer.onDurationChanged
                                      .listen((duration) {
                                    setState(() {
                                      _totalTime = duration.inMicroseconds;
                                    });
                                  });
                                  advancedPlayer.onAudioPositionChanged
                                      .listen((duration) {
                                    setState(() {
                                      _currentTime = duration.inMicroseconds;
                                      _percent = _currentTime.toDouble() /
                                          _totalTime.toDouble();
                                    });
                                  });
                                }),
                        _TouchIcon(
                            icon: Icons.stop,
                            onPressed: () {
                              advancedPlayer.stop();
                              setState(() {
                                _percent = 0.0;
                              });
                            }),
                        _TouchIcon(
                            icon: Icons.delete,
                            onPressed: () {
                              Directory appDirec =
                                  Directory(widget.records.elementAt(i));
                              appDirec.delete(recursive: true);
                              Fluttertoast.showToast(msg: "File Deleted");
                              setState(() {
                                widget.records
                                    .remove(widget.records.elementAt(i));
                              });
                            }),
                        _TouchIcon(
                            icon: Icons.share,
                            onPressed: () {
                              Directory appDirec =
                                  Directory(widget.records.elementAt(i));
                              List<String> list = List();
                              list.add(appDirec.path);
                              Share.shareFiles(list);
                            }),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTime({@required String filePath}) {
    String fromPath = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
    if (fromPath.startsWith("1", 0)) {
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(fromPath));
      int year = dateTime.year;
      int month = dateTime.month;
      int day = dateTime.day;
      int hour = dateTime.hour;
      int min = dateTime.minute;
      String timer = '$year-$month-$day--$hour:$min';
      return timer;
    } else {
      return "No Date";
    }
  }
}

class _TouchIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _TouchIcon({Key key, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 48.0,
      child: ElevatedButton(
          child: Icon(
            icon,
            color: Colors.white,
          ),
          onPressed: onPressed),
    );
  }
}
