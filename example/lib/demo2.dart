import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:y_calendar/y_calendar.dart';

class Demo2 extends StatelessWidget {
  const Demo2({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ValueNotifier<String>("");
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ValueListenableBuilder<String>(
            valueListenable: data,
            builder: (context, value, widget) {
              return value.isNotEmpty
                  ? Text(value, style: theme.textTheme.headlineSmall)
                  : const SizedBox();
            },
          ),
        ),
        FilledButton.tonalIcon(
          onPressed: () async {
            DateTime? date = await YCalendar<DateTime>().showBottomSheet(
              context,
            );
            if (date != null) {
              data.value = DateFormat('yyyy-MM-dd').format(date);
            }
          },
          style: FilledButton.styleFrom(minimumSize: Size.fromHeight(52.0)),
          icon: Icon(Icons.calendar_month),
          label: const Text('单个日期选择'),
        ),
      ],
    );
  }
}
