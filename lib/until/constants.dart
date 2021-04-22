import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;

  static String formatDuration(Duration duration) {
    int minute = duration.inMinutes;
    int second = (duration.inSeconds > 60)
        ? (duration.inSeconds % 60)
        : duration.inSeconds;
    print(duration.inMinutes.toString() +
        "======" +
        duration.inSeconds.toString());
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }
}
