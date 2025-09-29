import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:y_calendar/y_calendar.dart';

class Demo1 extends StatelessWidget {
  const Demo1({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ValueNotifier("");

    return Column(
      children: [
        ValueListenableBuilder<String>(
          valueListenable: data,
          builder: (context, value, widget) {
            return Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
        ElevatedButton(
          onPressed: () async {
            List<DateTime>? date = await YCalendar<List<DateTime>>(
              cumFlitter: true,
            ).showBottomSheet(context);
            data.value =
                date?.map(DateFormat('yyyy-MM-dd').format).toString() ?? "";
          },
          child: Text('范围选择'),
        ),
      ],
    );
  }
}
