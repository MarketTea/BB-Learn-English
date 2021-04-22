import 'dart:async';

import 'package:flutter/material.dart';

class LyricController extends ChangeNotifier {
  //Current progress
  Duration _progress = Duration();

  set progress(Duration value) {
    _progress = value;
    notifyListeners();
  }

  Duration get progress => _progress;

  //Sliding retainer
  Timer draggingTimer;

  //Sliding hold time
  Duration draggingTimerDuration;

  bool _isDragging = false;

  get isDragging => _isDragging;

  set isDragging(value) {
    _isDragging = value;
    notifyListeners();
  }

  Duration draggingProgress;

  Function draggingComplete;

  double draggingOffset;

  //Enable animation
  TickerProvider vsync;

  //Animation controller
  AnimationController animationController;

  //Animation Store the last offset
  double previousRowOffset = 0;

  int oldLine = 0;
  int draggingLine = 0;

  LyricController({this.vsync, this.draggingTimerDuration});
}
