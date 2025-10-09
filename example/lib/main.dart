import 'package:flutter/material.dart';
import 'package:y_calendar/y_calendar.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final theme = ValueNotifier<Color>(Colors.deepPurple);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, v, widget) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: v)),
          home: MyHomePage(
            onTheme: (color) {
              theme.value = color;
            },
          ),
        );
      },
      valueListenable: theme,
    );
  }
}
