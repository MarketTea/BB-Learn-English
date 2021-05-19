import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class Recorder extends StatefulWidget {
  final Function save;

  const Recorder({Key key, @required this.save}) : super(key: key);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  IconData _recordIcon = Icons.mic_none;
  MaterialColor color = Colors.orange;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording _current;

  // To Record Audio we need to create FlutterAudioRecorder instance
  FlutterAudioRecorder audioRecorder;

  @override
  void initState() {
    super.initState();

    FlutterAudioRecorder.hasPermissions.then((hasPermision) {
      if (hasPermision) {
        _currentStatus = RecordingStatus.Initialized;
        _recordIcon = Icons.mic;
      }
    });
  }

  @override
  void dispose() {
    _currentStatus = RecordingStatus.Unset;
    audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              _current?.duration?.toString()?.substring(0, 7) ?? "0:0:0:0",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            stop == false
                ? RaisedButton(
                    color: Colors.red,
                    onPressed: () async {
                      await _onRecordButtonPressed();
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Icon(
                            _recordIcon,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: color,
                          onPressed: () async {
                            await _onRecordButtonPressed();
                            setState(() {});
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Icon(
                              _recordIcon,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.orange,
                          onPressed: _currentStatus != RecordingStatus.Unset
                              ? _stop
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          _recorder();
          break;
        }
      case RecordingStatus.Recording:
        {
          _pause();
          break;
        }
      case RecordingStatus.Paused:
        {
          _resume();
          break;
        }
      case RecordingStatus.Stopped:
        {
          _recorder();
          break;
        }
      default:
        break;
    }
  }

  _initial() async {
    Directory appDir = await getExternalStorageDirectory();
    String record = 'Audiorecords';
    String url = "${DateTime.now()?.millisecondsSinceEpoch?.toString()}.wav";
    Directory appDirectory =
        Directory("${appDir.parent.parent.parent.parent.path}/$record/");
    if (await appDirectory.exists()) {
      String pathURL = "${appDirectory.path}$url";
      audioRecorder =
          FlutterAudioRecorder(pathURL, audioFormat: AudioFormat.WAV);
      await audioRecorder.initialized;
    } else {
      appDirectory.create(recursive: true);
      Fluttertoast.showToast(msg: "Start Recording , Press Start");
      String pathURL = "${appDirectory.path}$url";
      audioRecorder =
          FlutterAudioRecorder(pathURL, audioFormat: AudioFormat.WAV);
      await audioRecorder.initialized;
    }
  }

  _start() async {
    await audioRecorder.start();
    var recording = await audioRecorder.current(channel: 0);
    setState(() {
      _current = recording;
    });

    const tick = const Duration(milliseconds: 50);
    new Timer.periodic(tick, (Timer t) async {
      if (_currentStatus == RecordingStatus.Stopped) {
        t.cancel();
      }

      var current = await audioRecorder.current(channel: 0);
      // print(current.status);
      setState(() {
        _current = current;
        _currentStatus = _current.status;
      });
    });
  }

  _resume() async {
    await audioRecorder.resume();
    Fluttertoast.showToast(msg: "Resume Recording");
    setState(() {
      _recordIcon = Icons.pause;
      color = Colors.red;
    });
  }

  _pause() async {
    await audioRecorder.pause();
    Fluttertoast.showToast(msg: "Pause Recording");
    setState(() {
      _recordIcon = Icons.mic;
      color = Colors.green;
    });
  }

  _stop() async {
    var result = await audioRecorder.stop();
    Fluttertoast.showToast(msg: "Stop Recording, File Saved");
    widget.save();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _current.duration = null;
      _recordIcon = Icons.mic;
      stop = false;
    });
  }

  Future<void> _recorder() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      await _initial();
      await _start();
      Fluttertoast.showToast(msg: "Start Recording");
      setState(() {
        _currentStatus = RecordingStatus.Recording;
        _recordIcon = Icons.pause;
        color = Colors.red;
        stop = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Allow App To Use Mic");
    }
  }
}
