import 'package:flutter/material.dart';

import 'y_month_title.dart';

class Status {
  const Status(this.text, this.bgColor, this.textColor, this.radius);

  final String text;
  final Color? bgColor;
  final Color? textColor;
  final BorderRadius? radius;
}

class YMonthItem extends StatelessWidget {
  const YMonthItem({
    super.key,
    required this.month,
    required this.color,
    required this.minDate,
    required this.maxDate,
    required this.isRange,
    required this.selectDate,
    this.onSelect,
  });

  final DateTime month;
  final Color color;
  final DateTime minDate;
  final DateTime maxDate;
  final bool isRange;
  final List<DateTime?> selectDate;
  final ValueChanged<DateTime>? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int currentYear = month.year;
    int currentMonth = month.month;

    int lastDay = DateTime(currentYear, currentMonth + 1, 0).day;
    int emptyDays = DateTime(currentYear, currentMonth, 1).weekday % 7;

    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: Stack(
            children: <Widget>[
              // 背景
              Align(
                child: Text(
                  "$currentMonth",
                  style: TextStyle(
                    fontSize: 150.0,
                    fontWeight: FontWeight.w500,
                    color: color.withAlpha(10),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  YMonthTitle(year: currentYear, month: currentMonth),
                  Wrap(
                    children: List.generate(lastDay + emptyDays, (i) {
                      int day = i - emptyDays + 1;

                      DateTime currentDate = DateTime(
                        currentYear,
                        currentMonth,
                        day,
                      );
                      bool isEmpty = day < 1;
                      bool disable =
                          currentDate.isBefore(DateUtils.dateOnly(minDate)) ||
                          currentDate.isAfter(DateUtils.dateOnly(maxDate));

                      Status status = Status(
                        "",
                        null,
                        theme.colorScheme.inverseSurface,
                        null,
                      );
                      if (isRange) {
                        if (selectDate.length == 2 &&
                            DateUtils.isSameDay(
                              selectDate.first,
                              selectDate.last,
                            ) &&
                            DateUtils.isSameDay(
                              currentDate,
                              selectDate.first,
                            )) {
                          status = Status(
                            "开始/结束",
                            color,
                            Colors.white,
                            BorderRadius.circular(4.0),
                          );
                        } else if (selectDate.isNotEmpty &&
                            DateUtils.isSameDay(
                              currentDate,
                              selectDate.first,
                            )) {
                          status = Status(
                            "开始",
                            color,
                            Colors.white,
                            BorderRadius.horizontal(left: Radius.circular(4.0)),
                          );
                        } else if (selectDate.length == 2 &&
                            !isEmpty &&
                            currentDate.isAfter(selectDate.first!) &&
                            currentDate.isBefore(selectDate.last!)) {
                          status = Status(
                            "",
                            color.withAlpha((255 * 0.1).round()),
                            null,
                            null,
                          );
                        } else if (selectDate.length == 2 &&
                            DateUtils.isSameDay(currentDate, selectDate.last)) {
                          status = Status(
                            "结束",
                            color,
                            Colors.white,
                            BorderRadius.horizontal(
                              right: Radius.circular(4.0),
                            ),
                          );
                        }
                      } else {
                        if (!isEmpty &&
                            selectDate.isNotEmpty &&
                            DateUtils.isSameDay(
                              currentDate,
                              selectDate.first,
                            )) {
                          status = Status(
                            "",
                            color,
                            Colors.white,
                            BorderRadius.circular(4.0),
                          );
                        }
                      }

                      return SizedBox(
                        width: (constraints.maxWidth ~/ 7).toDouble(),
                        height: 60.0,
                        child: Visibility(
                          visible: !isEmpty,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: status.radius,
                                color: status.bgColor,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4.0),
                                onTap:
                                    isEmpty || disable
                                        ? null
                                        : () => onSelect?.call(currentDate),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "$day",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              disable
                                                  ? theme.colorScheme.outlineVariant
                                                  : status.textColor,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(0, 0.8),
                                      child: Text(
                                        status.text,
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
