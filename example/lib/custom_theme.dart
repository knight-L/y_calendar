import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme(this.mode, this.color);

  final ThemeMode mode;
  final Color color;

  CustomTheme copyWith({ThemeMode? mode, Color? color}) {
    return CustomTheme(mode ?? this.mode, color ?? this.color);
  }
}