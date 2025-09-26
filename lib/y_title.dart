import 'package:flutter/material.dart';

class YTitle extends StatelessWidget {
  const YTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          height: 44.0,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xff323233),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Align(alignment: Alignment.topRight, child: CloseButton()),
      ],
    );
  }
}
