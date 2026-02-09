import 'package:flutter/material.dart';

import 'y_title.dart';
import 'y_weekdays.dart';

class YTop extends StatelessWidget {
  const YTop({super.key, required this.title, this.round});

  final String title;
  final BorderRadiusGeometry? round;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: round,
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.07),
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 0, // has the effect of extending the shadow
            offset: Offset(
              0, // horizontal, move right 10
              10, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Column(children: <Widget>[YTitle(title: title), YWeekdays()]),
    );
  }
}
