import 'package:flutter/material.dart';

import 'lyric.dart';

class LyricPainter extends CustomPainter with ChangeNotifier {
  List<Lyric> lyrics;
  Size canvasSize = Size.zero;
  double lyricMaxWidth;
  double lyricGapValue;

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

  //Current lyrics style
  TextStyle currLyricTextStyle;

  //Swipe to the line
  int _draggingLine;

  get draggingLine => _draggingLine;

  set draggingLine(value) {
    this._draggingLine = value;
    notifyListeners();
  }

  final List<TextPainter> lyricTextPaints;

  LyricPainter(this.lyrics, this.lyricTextPaints,
      {TickerProvider vsync,
      this.lyricTextStyle,
      this.currLyricTextStyle,
      this.lyricGapValue,
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
        size.height / 20 -
        lyricTextPaints[currentLyricIndex].height / 2;
    print('Current Y: ' + currentLyricY.toString());

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
                    ? lyricTextStyle
                    : lyricTextStyle)
        ..layout(maxWidth: lyricMaxWidth); // <=> currentLyricTextPaint.layout
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
      print('ABC_Y: ' + currentLyricY.toString());
    }
  }

  @override
  bool shouldRepaint(LyricPainter oldDelegate) {
    //Redraw when the lyrics progress changes
    return oldDelegate.currentLyricIndex != currentLyricIndex;
  }
}
