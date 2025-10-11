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
      children: [
        ValueListenableBuilder<String>(
          valueListenable: data,
          builder: (context, value, widget) {
            return Text(value, style: theme.textTheme.headlineMedium);
          },
        ),
        ElevatedButton(
          onPressed: () async {
            List<DateTime>? date = await YCalendar<List<DateTime>>(
              presets: presets,
            ).showBottomSheet(context);
            if (date != null) {
              data.value = date.map(DateFormat('yyyy-MM-dd').format).toString();
            }
          },
          child: Text('范围选择'),
        ),
      ],
    );
  }
}
