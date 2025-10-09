import 'package:flutter/material.dart';

import 'custom_theme.dart';
import 'demo1.dart';
import 'demo2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.theme,
    this.onTheme,
    this.onThemeMode,
  });

  final CustomTheme theme;
  final ValueChanged<Color>? onTheme;
  final ValueChanged<ThemeMode>? onThemeMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("日期选择组件示例"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text("跟随系统"),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text("浅色模式"),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text("深色模式"),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {widget.theme.mode},
              onSelectionChanged: (v) {
                widget.onThemeMode?.call(v.first);
              },
            ),
            SizedBox(height: 20.0),
            Wrap(
              alignment: WrapAlignment.center,
              children:
                  Colors.primaries.map((color) {
                    return Ink(
                      color: color,
                      width: 50.0,
                      height: 50.0,
                      child: InkWell(
                        onTap: () {
                          widget.onTheme?.call(color);
                        },
                      ),
                    );
                  }).toList(),
            ),
            Demo1(),
            Demo2(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
