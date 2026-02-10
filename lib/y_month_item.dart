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
        return Column(
          children: <Widget>[
            YMonthTitle(year: currentYear, month: currentMonth),
            IntrinsicHeight(
              child: Stack(
                children: <Widget>[
                  // 背景
                  Align(
                    child: Text(
                      "$currentMonth",
                      style: TextStyle(
                        fontSize: 150.0,
                        fontWeight: FontWeight.w500,
                        color: color.withValues(alpha: 0.03),
                      ),
                    ),
                  ),
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

                      // 1. 提取常用的变量，减少属性访问
                      final firstDate =
                          selectDate.isNotEmpty ? selectDate.first : null;
                      final lastDate =
                          selectDate.length == 2 ? selectDate.last : null;

                      // 2. 提前计算状态布尔值
                      final isFirstDay =
                          firstDate != null &&
                          DateUtils.isSameDay(currentDate, firstDate);
                      final isLastDay =
                          lastDate != null &&
                          DateUtils.isSameDay(currentDate, lastDate);
                      final isBetween =
                          firstDate != null &&
                          lastDate != null &&
                          currentDate.isAfter(firstDate) &&
                          currentDate.isBefore(lastDate);

                      // 默认状态（兜底）
                      Status status = Status(
                        "",
                        null,
                        theme.colorScheme.inverseSurface,
                        null,
                      );

                      if (isRange) {
                        if (isFirstDay && isLastDay) {
                          // 选中了同一天作为开始和结束
                          status = Status(
                            "开始/结束",
                            color,
                            Colors.white,
                            BorderRadius.circular(4.0),
                          );
                        } else if (isFirstDay) {
                          status = Status(
                            "开始",
                            color,
                            Colors.white,
                            BorderRadius.horizontal(left: Radius.circular(4.0)),
                          );
                        } else if (isLastDay) {
                          status = Status(
                            "结束",
                            color,
                            Colors.white,
                            BorderRadius.horizontal(
                              right: Radius.circular(4.0),
                            ),
                          );
                        } else if (isBetween) {
                          status = Status(
                            "",
                            color.withValues(alpha: 0.1),
                            null,
                            null,
                          );
                        }
                      } else if (!isEmpty && isFirstDay) {
                        // 单选模式
                        status = Status(
                          "",
                          color,
                          Colors.white,
                          BorderRadius.circular(4.0),
                        );
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
                                                  ? theme
                                                      .colorScheme
                                                      .outlineVariant
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
            ),
          ],
        );
      },
    );
  }
}
