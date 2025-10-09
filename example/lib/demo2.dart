import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:y_calendar/y_calendar.dart';

class Demo2 extends StatelessWidget {
  const Demo2({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ValueNotifier("");
    final theme = Theme.of(context);

    return Column(
      children: [
        ValueListenableBuilder<String>(
          valueListenable: data,
          builder: (context, value, widget) {
            return Text(value, style: theme.textTheme.headlineMedium);
          },
        ),
        ElevatedButton(
          onPressed: () async {
            final date = await YCalendar<DateTime>().showBottomSheet(context);
            if (date != null) {
              data.value = DateFormat('yyyy-MM-dd').format(date);
            }
          },
          child: Text('单个日期选择'),
        ),
      ],
    );
  }
}
