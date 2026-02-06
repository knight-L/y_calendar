import 'package:flutter/material.dart';

import 'custom_theme.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final theme = ValueNotifier<CustomTheme>(
    CustomTheme(ThemeMode.system, Colors.deepPurple),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, v, widget) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: v.mode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: v.color,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: v.color,
              brightness: Brightness.dark,
            ),
          ),
          home: MyHomePage(
            theme: v,
            onTheme: (color) {
              theme.value = v.copyWith(color: color);
            },
            onThemeMode: (mode) {
              theme.value = v.copyWith(mode: mode);
            },
          ),
        );
      },
      valueListenable: theme,
    );
  }
}
