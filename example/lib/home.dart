import 'package:flutter/material.dart';

import 'demo1.dart';
import 'demo2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.onTheme});

  final ValueChanged<Color>? onTheme;

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
