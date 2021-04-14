import 'package:flutter/material.dart';

import 'lyric.dart';

class LyricPainter extends CustomPainter with ChangeNotifier {
  List<Lyric> lyrics;
  List<Lyric> subLyrics;
  Size canvasSize = Size.zero;
  double lyricMaxWidth;
  double lyricGapValue;
  double subLyricGapValue;

  //Control lyrics sliding by offset
  double _offset = 0;

  set offset(value) {
    _offset = value;
    notifyListeners();
  }

  get offset => _offset;

  //Lyric position
  int _currentLyricIndex = 0;

  get currentLyricIndex => _currentLyricIndex;

  set currentLyricIndex(value) {
    _currentLyricIndex = value;
    notifyListeners();
  }

  //Lyric style
  TextStyle lyricTextStyle;

  //Sliding lyrics style
  TextStyle draggingLyricTextStyle;

  //Sliding sub lyrics style
  TextStyle draggingSubLyricTextStyle;

  //Translation/Transliteration Lyrics Style
  TextStyle subLyricTextStyle;

  //Current lyrics style
  TextStyle currLyricTextStyle;

  //Current sub lyrics style
  TextStyle currSubLyricTextStyle;

  //Swipe to the line
  int _draggingLine;

  get draggingLine => _draggingLine;

  set draggingLine(value) {
    this._draggingLine = value;
    notifyListeners();
  }

  final List<TextPainter> lyricTextPaints;
  final List<TextPainter> subLyricTextPaints;

  LyricPainter(this.lyrics, this.lyricTextPaints, this.subLyricTextPaints,
      {this.subLyrics,
      TickerProvider vsync,
      this.lyricTextStyle,
      this.subLyricTextStyle,
      this.currLyricTextStyle,
      this.currSubLyricTextStyle,
      this.draggingLyricTextStyle,
      this.draggingSubLyricTextStyle,
      this.lyricGapValue,
      this.subLyricGapValue,
      this.lyricMaxWidth});

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;

    //The Y coordinate of the initial lyrics is in the center
    lyricTextPaints[currentLyricIndex]
      //Set lyrics
      ..text = TextSpan(
          text: lyrics[currentLyricIndex].lyric, style: currLyricTextStyle)
      ..layout(maxWidth: lyricMaxWidth);
    var currentLyricY = _offset +
        size.height / 2 -
        lyricTextPaints[currentLyricIndex].height / 2;

    //Traverse the lyrics to draw
    for (int lyricIndex = 0; lyricIndex < lyrics.length; lyricIndex++) {
      var currentLyric = lyrics[lyricIndex];
      var isCurrLine = currentLyricIndex == lyricIndex;
      var isDraggingLine = _draggingLine == lyricIndex;
      var currentLyricTextPaint = lyricTextPaints[lyricIndex]
        //Set lyrics
        ..text = TextSpan(
            text: currentLyric.lyric,
            style: isCurrLine
                ? currLyricTextStyle
                : isDraggingLine
                    ? draggingLyricTextStyle
                    : lyricTextStyle);
      currentLyricTextPaint.layout(maxWidth: lyricMaxWidth);
      var currentLyricHeight = currentLyricTextPaint.height;

      //Lyrics drawn only on the screen
      if (currentLyricY < size.height && currentLyricY > 0) {
        //Draw lyrics to the canvas
        currentLyricTextPaint
          ..paint(
              canvas,
              Offset((size.width - currentLyricTextPaint.width) / 2,
                  currentLyricY));
      }
      //After the current lyrics is over, adjust the y coordinate of the next lyrics to be drawn
      currentLyricY += currentLyricHeight + lyricGapValue;
      //If there are translated lyrics, look for the translated lyrics of the line in the future
      if (subLyrics != null) {
        List<Lyric> remarkLyrics = subLyrics
            .where((subLyric) =>
                subLyric.startTime >= currentLyric.startTime &&
                subLyric.endTime <= currentLyric.endTime)
            .toList();
        remarkLyrics.forEach((remarkLyric) {
          //Get position
          var subIndex = subLyrics.indexOf(remarkLyric);

          var currentSubPaint = subLyricTextPaints[subIndex] //设置歌词
            ..text = TextSpan(
                text: remarkLyric.lyric,
                style: isCurrLine
                    ? currSubLyricTextStyle
                    : isDraggingLine
                        ? draggingSubLyricTextStyle
                        : subLyricTextStyle);
          //Lyrics drawn only on the screen
          if (currentLyricY < size.height && currentLyricY > 0) {
            currentSubPaint
              //Calculate text width and height
              ..layout(maxWidth: lyricMaxWidth)
              //Draw offset = Horizontal center
              ..paint(
                  canvas,
                  Offset((size.width - subLyricTextPaints[subIndex].width) / 2,
                      currentLyricY));
          }
          currentSubPaint..layout(maxWidth: lyricMaxWidth);
          //After the current lyrics is over, adjust the y coordinate of the next lyrics to be drawn
          currentLyricY += currentSubPaint.height + subLyricGapValue;
        });
      }
    }
  }

  @override
  bool shouldRepaint(LyricPainter oldDelegate) {
    //Redraw when the lyrics progress changes
    return oldDelegate.currentLyricIndex != currentLyricIndex;
  }
}
