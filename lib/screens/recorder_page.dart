import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learning_english/components/recorded_list_view.dart';
import 'package:learning_english/components/recorder_view.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderPage extends StatefulWidget {
  @override
  _AudioRecorderPageState createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  Directory appDir;
  List<String> records;

  /// Fetch and Display all Recordings
  /// To fetch the saved recordings we need to pass out file directory path to Directory class .
  /// This will return list of files inside the folder

  @override
  void initState() {
    super.initState();
    records = [];
    getExternalStorageDirectory().then((value) {
      appDir = value.parent.parent.parent.parent;
      Directory appDirect = Directory("${appDir.path}/Audiorecords/");
      appDir = appDirect;
      appDir.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDir = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: InkWell(
          child: Icon(Icons.mic, color: Colors.white,),
          onTap: () {
            show(context);
          },
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Recordings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Records(
              records: records,
            ),
          ),
        ],
      ),
    );
  }

  _onFinish() {
    records.clear();
    print(records.length.toString());
    appDir.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Recorder(
            save: _onFinish,
          ),
        );
      },
    );
  }
}
