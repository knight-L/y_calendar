import 'package:flutter/material.dart';

class YMonthTitle extends StatelessWidget {
  const YMonthTitle({super.key, this.year, this.month});

  final int? year;
  final int? month;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      height: 44.0,
      child: Text(
        "$year年$month月",
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xff323233),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
