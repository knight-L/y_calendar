import 'package:flutter/material.dart';

const List weekdays = ["日", "一", "二", "三", "四", "五", "六"];

class YWeekdays extends StatelessWidget {
  const YWeekdays({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 30.0,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 14.0,
          color: theme.colorScheme.inverseSurface,
        ),
        child: Row(
          children: List.generate(weekdays.length, (i) {
            return Expanded(child: Center(child: Text(weekdays[i])));
          }),
        ),
      ),
    );
  }
}
