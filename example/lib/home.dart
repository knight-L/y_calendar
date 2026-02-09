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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: theme.colorScheme.inversePrimary,
        title: Text("日期选择组件示例"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Title(color: Colors.grey, child: Text('主题模式')),
              const SizedBox(height: 8.0),
              SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(
                      "跟随系统",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    icon: Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(
                      "浅色模式",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    icon: Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(
                      "深色模式",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    icon: Icon(Icons.dark_mode),
                  ),
                ],
                selected: {widget.theme.mode},
                onSelectionChanged: (v) {
                  widget.onThemeMode?.call(v.first);
                },
              ),
              const SizedBox(height: 20.0),
              Title(color: Colors.grey, child: Text('主题颜色')),
              const SizedBox(height: 8.0),
              GridView.count(
                crossAxisCount: 6,
                childAspectRatio: 2.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                shrinkWrap: true,
                primary: false,
                children: [
                  ...Colors.primaries.map(
                    (color) => Ink(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25.0),
                        child:
                            widget.theme.color == color
                                ? Icon(Icons.check, color: Colors.white)
                                : null,
                        onTap: () {
                          widget.onTheme?.call(color);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Title(color: Colors.grey, child: Text('功能示例')),
              const SizedBox(height: 8.0),
              Demo1(),
              const SizedBox(height: 20.0),
              Demo2(),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
