import 'package:flutter/material.dart';

class YMonthTitle extends StatelessWidget {
  const YMonthTitle({super.key, this.year, this.month});

  final int? year;
  final int? month;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: AlignmentDirectional.center,
      height: 44.0,
      child: Text(
        "$year年$month月",
        style: TextStyle(
          fontSize: 14.0,
          color: theme.colorScheme.inverseSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
