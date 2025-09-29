import 'package:flutter/material.dart';

import 'y_title.dart';
import 'y_weekdays.dart';

class YTop extends StatelessWidget {
  const YTop({super.key, required this.title, this.round});

  final String title;
  final BorderRadiusGeometry? round;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: round,
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 0, // has the effect of extending the shadow
            offset: Offset(
              0, // horizontal, move right 10
              2, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Column(children: <Widget>[YTitle(title: title), YWeekdays()]),
    );
  }
}
