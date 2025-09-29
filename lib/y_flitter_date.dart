import 'package:flutter/material.dart';
import '../utils/date_util.dart';

class YFlitterDate extends StatefulWidget {
  const YFlitterDate({super.key, this.onChange});

  final ValueChanged<List<String>>? onChange;

  @override
  State<YFlitterDate> createState() => _YFlitterDateState();
}

class _YFlitterDateState extends State<YFlitterDate> {
  final DateTime _nowTime = DateTime.now();

  get _tabs => [
    {'label': '本周', 'value': DateUtil.getThisWeek(_nowTime)},
    {'label': '上周', 'value': DateUtil.getLastWeek(_nowTime)},
    {'label': '下周', 'value': DateUtil.getNextWeek(_nowTime)},
    {'label': '本月', 'value': DateUtil.getThisMonth(_nowTime)},
    {'label': '上月', 'value': DateUtil.getLastMonth(_nowTime)},
    {'label': '下月', 'value': DateUtil.getNextMonth(_nowTime)},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 6,
      childAspectRatio: 1.5,
      children: List.generate(_tabs.length, (index) {
        return ActionChip(
          label: Text(_tabs[index]['label']),
          visualDensity: VisualDensity.compact,
          labelStyle: theme.textTheme.labelSmall,
          onPressed: () {
            widget.onChange?.call(_tabs[index]['value']);
          },
        );
      }),
    );
  }
}
