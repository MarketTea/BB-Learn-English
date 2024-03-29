import 'dart:async';

import 'package:flutter/material.dart';
import 'lyric.dart';
import 'lyric_controller.dart';
import 'lyric_painter.dart';

// ignore: must_be_immutable
class LyricWidget extends StatefulWidget {
  final List<Lyric> lyrics;
  final Size size;
  final LyricController controller;
  TextStyle lyricStyle;
  TextStyle currLyricStyle;
  final double lyricGap;
  bool enableDrag;

  //Lyrics brush array
  List<TextPainter> lyricTextPaints = [];

  //Maximum font width
  double lyricMaxWidth;

  LyricWidget(
      {Key key,
      @required this.lyrics,
      @required this.size,
      this.controller,
      this.lyricStyle,
      this.currLyricStyle,
      this.lyricGap: 10,
      this.enableDrag: true,
      this.lyricMaxWidth,
      })
      : assert(enableDrag != null),
        assert(lyrics != null && lyrics.isNotEmpty),
        assert(size != null),
        assert(controller != null) {
    this.lyricStyle ??= TextStyle(color: Colors.grey, fontSize: 14);
    this.currLyricStyle ??= TextStyle(color: Colors.red, fontSize: 14);

    //Lyrics to brush
    lyricTextPaints.addAll(lyrics
        .map((l) => TextPainter(
              text: TextSpan(text: l.lyric, style: lyricStyle),
              textDirection: TextDirection.ltr),
        ).toList());

  }

  @override
  _LyricWidgetState createState() => _LyricWidgetState();
}

class _LyricWidgetState extends State<LyricWidget> {
  LyricPainter _lyricPainter;
  double totalHeight = 0;

  @override
  void initState() {
    widget.controller.draggingComplete = () {
      cancelTimer();
      widget.controller.progress = widget.controller.draggingProgress;
      _lyricPainter.draggingLine = null;
      widget.controller.isDragging = false;
    };

    WidgetsBinding.instance.addPostFrameCallback((call) {
      totalHeight = computeScrollY(widget.lyrics.length - 1);
      print('TEAM totalHeight: ' + totalHeight.toString());
    });

    widget.controller.addListener(() {
      var curLine =
          findLyricIndexByDuration(widget.controller.progress, widget.lyrics);
      if (widget.controller.oldLine != curLine) {
        _lyricPainter.currentLyricIndex = curLine;
        if (!widget.controller.isDragging) {
          if (widget.controller.vsync == null) {
            _lyricPainter.offset = -computeScrollY(curLine);
          } else {
            animationScrollY(curLine, widget.controller.vsync);
          }
        }
        widget.controller.oldLine = curLine;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyricMaxWidth == null || widget.lyricMaxWidth == double.infinity) {
      widget.lyricMaxWidth = MediaQuery.of(context).size.width;
    }

    _lyricPainter = LyricPainter(
        widget.lyrics,
        widget.lyricTextPaints,
        vsync: widget.controller.vsync,
        lyricTextStyle: widget.lyricStyle,
        currLyricTextStyle: widget.currLyricStyle,
        lyricGapValue: widget.lyricGap,
        lyricMaxWidth: widget.lyricMaxWidth,
    );

    _lyricPainter.currentLyricIndex =
        findLyricIndexByDuration(widget.controller.progress, widget.lyrics);
    if (widget.controller.isDragging) {
      _lyricPainter.draggingLine = widget.controller.draggingLine;
      _lyricPainter.offset = widget.controller.draggingOffset;
    } else {
      _lyricPainter.offset = -computeScrollY(_lyricPainter.currentLyricIndex);
    }

    return widget.enableDrag
        ? GestureDetector(
            onVerticalDragUpdate: (e) {
              cancelTimer();
              double temOffset = (_lyricPainter.offset + e.delta.dy);
              print("CHECK VALUE SCROLL:------" + temOffset.toString());
              if (temOffset < 0 && temOffset >= -totalHeight) {
                widget.controller.draggingOffset = temOffset;
                widget.controller.draggingLine = getCurrentDraggingLine(temOffset + widget.lyricGap);
                _lyricPainter.draggingLine = widget.controller.draggingLine;
                print("CHECK VALUE SCROLL draggingLine:------" + _lyricPainter.draggingLine.toString());
                widget.controller.draggingProgress = widget.lyrics[widget.controller.draggingLine].startTime + Duration(milliseconds: 1);
                widget.controller.isDragging = false;
                _lyricPainter.offset = temOffset;
              }
            },
            onVerticalDragEnd: (e) {
              cancelTimer();
              widget.controller.draggingTimer = Timer(
                  widget.controller.draggingTimerDuration ??
                      Duration(seconds: 3), () {
                resetDragging();
              });
            },
            child: buildCustomPaint(),
          )
        : buildCustomPaint();
  }

  CustomPaint buildCustomPaint() {
    return CustomPaint(
      painter: _lyricPainter,
      size: widget.size,
    );
  }

  void resetDragging() {
    _lyricPainter.currentLyricIndex =
        findLyricIndexByDuration(widget.controller.progress, widget.lyrics);

    widget.controller.previousRowOffset = -widget.controller.draggingOffset;
    animationScrollY(_lyricPainter.currentLyricIndex, widget.controller.vsync);
    _lyricPainter.draggingLine = null;
    widget.controller.isDragging = false;
  }

  int getCurrentDraggingLine(double offset) {
    for (int i = 0; i < widget.lyrics.length; i++) {
      var scrollY = computeScrollY(i);
      if (offset > -1) {
        offset = 0;
      }
      if (offset >= -scrollY) {
        return i;
      }
    }
    return widget.lyrics.length;
  }

  void cancelTimer() {
    if (widget.controller.draggingTimer != null) {
      if (widget.controller.draggingTimer.isActive) {
        widget.controller.draggingTimer.cancel();
        widget.controller.draggingTimer = null;
      }
    }
  }

  animationScrollY(currentLyricIndex, TickerProvider tickerProvider) {
    var animationController = widget.controller.animationController;
    if (animationController != null) {
      animationController.stop();
    }
    animationController = AnimationController(
        vsync: tickerProvider, duration: Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.dispose();
          animationController = null;
        }
      });

    /// Calculate the current row offset
    var currentRowOffset = computeScrollY(currentLyricIndex);

    /// Do not perform animation if the offsets are the same
    if (currentRowOffset == widget.controller.previousRowOffset) {
      return;
    }

    /// The start is the previous line, and the end point is the current line
    Animation animation = Tween<double>(
            begin: widget.controller.previousRowOffset, end: currentRowOffset)
        .animate(animationController);
    widget.controller.previousRowOffset = currentRowOffset;
    animationController.addListener(() {
      _lyricPainter.offset = -animation.value;
    });
    animationController.forward();
  }

  ///Tìm vị trí của lời bài hát theo thời lượng hiện tại
  int findLyricIndexByDuration(Duration curDuration, List<Lyric> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= lyrics[i].startTime &&
          curDuration <= lyrics[i].endTime) {
        return i;
      }
    }
    return 0;
  }

  /// Tính độ lệch giữa dòng đến và dòng đầu tiên
  double computeScrollY(int curLine) {
    double totalHeight = 0;
    for (var i = 0; i < curLine; i++) {
      var currPaint = widget.lyricTextPaints[i]
        ..text = TextSpan(text: widget.lyrics[i].lyric, style: widget.currLyricStyle);
      currPaint.layout(maxWidth: widget.lyricMaxWidth);
      totalHeight += currPaint.height + widget.lyricGap;
    }

    return totalHeight;
  }
}
