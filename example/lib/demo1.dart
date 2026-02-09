import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:y_calendar/y_calendar.dart';

class Demo1 extends StatelessWidget {
  const Demo1({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ValueNotifier("");
    final theme = Theme.of(context);

    final DateTime nowTime = DateTime.now();

    final Map<String, List<DateTime>> presets = {
      '本周': DateUtil.getThisWeek(nowTime),
      '上周': DateUtil.getLastWeek(nowTime),
      '下周': DateUtil.getNextWeek(nowTime),
      '本月': DateUtil.getThisMonth(nowTime),
      '上月': DateUtil.getLastMonth(nowTime),
      '下月': DateUtil.getNextMonth(nowTime),
    };

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
            List<DateTime>? date = await YCalendar<List<DateTime>>(
              presets: presets,
            ).showBottomSheet(context);
            if (date != null) {
              data.value = date.map(DateFormat('yyyy-MM-dd').format).toString();
            }
          },
          style: FilledButton.styleFrom(minimumSize: Size.fromHeight(52.0)),
          icon: Icon(Icons.calendar_month),
          label: const Text('日期范围选择'),
        ),
      ],
    );
  }
}
