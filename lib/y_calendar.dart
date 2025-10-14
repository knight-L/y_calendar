library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'y_month_item.dart';
import 'y_top.dart';

part './utils/date_util.dart';

class YCalendar<T> extends StatefulWidget {
  // 日历标题
  final String title;

  // 颜色，对底部按钮和选中日期生效
  final Color? color;

  // 最小日期
  final DateTime? minDate;

  // 最大日期
  final DateTime? maxDate;

  // 默认选中的日期
  final T? defaultDate;

  // 是否显示圆角弹窗
  final BorderRadiusGeometry round;

  // 是否展示确认按钮
  final bool showConfirm;

  // 是否在点击遮罩层后关闭
  final bool closeOnClickOverlay;

  // 确认按钮的文字
  final String confirmText;

  // 日程高度
  final double height;

  // 自定义过滤项
  final Map<String, List<DateTime>>? presets;

  const YCalendar({
    super.key,
    this.title = "日期选择",
    this.color,
    this.minDate,
    this.maxDate,
    this.defaultDate,
    this.round = const BorderRadius.vertical(top: Radius.circular(20.0)),
    this.showConfirm = true,
    this.closeOnClickOverlay = true,
    this.confirmText = "确定",
    this.height = 400.0,
    this.presets,
  }) : assert(
         T == DateTime || T == List<DateTime>,
         'T 只能是 DateTime 或 List<DateTime>，但传入的是 $T',
       );

  @override
  State<YCalendar> createState() => _YCalendarState<T>();

  /// 将日历作为底部弹窗显示
  Future<T?> showBottomSheet(
    BuildContext context, {
    bool isScrollControlled = true,
    Color backgroundColor = Colors.transparent,
    bool isDismissible = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      builder: (context) => this,
    );
  }
}

class _YCalendarState<T> extends State<YCalendar<T>> {
  List<DateTime> _currentDate = [];
  late DateTime _minDate;
  late DateTime _maxDate;
  bool _isRange = false;
  int _initialMonthIndex = 0;
  final DateTime dateOnly = DateUtils.dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    _isRange = T == List<DateTime>;
    _minDate = widget.minDate ?? DateTime(dateOnly.year - 1);
    _maxDate = widget.maxDate ?? DateTime(dateOnly.year + 2, 1, 0);

    onChange(
      widget.defaultDate != null
          ? _isRange
              ? widget.defaultDate as List<DateTime>
              : [widget.defaultDate as DateTime]
          : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onChange(List<DateTime>? date) {
    _initialMonthIndex = DateUtils.monthDelta(
      _minDate,
      date != null ? date.first : dateOnly,
    );
    if (date == null) return;

    setState(() {
      if (_isRange) {
        _currentDate =
            date.map((e) {
              var newEl = DateUtils.dateOnly(e);
              return newEl.isAfter(_maxDate) ? _maxDate : newEl;
            }).toList();
      } else {
        _currentDate = [date.first];
      }
    });
  }

  void close(T date) {
    Navigator.pop(context, date);
  }

  void select(DateTime value) {
    setState(() {
      if (_isRange) {
        // 范围
        if (_currentDate.length >= 2 ||
            (_currentDate.isNotEmpty && value.isBefore(_currentDate.first))) {
          _currentDate.clear();
        }
        _currentDate.add(value);

        if (!widget.showConfirm && _currentDate.length == 2) {
          close(_currentDate as T);
        }
      } else {
        // 单选
        _currentDate.insert(0, value);
        if (!widget.showConfirm) {
          close(_currentDate.first as T);
        }
      }
    });
  }

  void confirm() {
    close(_isRange ? _currentDate as T : _currentDate.first as T);
  }

  int get _numberOfMonths => DateUtils.monthDelta(_minDate, _maxDate) + 1;

  final Key sliverAfterKey = Key('sliverAfterKey');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return AspectRatio(
      aspectRatio: 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.round,
          color: theme.cardColor,
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    YTop(title: widget.title, round: widget.round),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomScrollView(
                          center: sliverAfterKey,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) => YMonthItem(
                                  color: color,
                                  minDate: _minDate,
                                  maxDate: _maxDate,
                                  isRange: _isRange,
                                  selectDate: _currentDate,
                                  month: DateUtils.addMonthsToMonthDate(
                                    _minDate,
                                    _initialMonthIndex - index - 1,
                                  ),
                                  onSelect: select,
                                ),
                                childCount: _initialMonthIndex,
                              ),
                            ),
                            SliverList(
                              key: sliverAfterKey,
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => YMonthItem(
                                  color: color,
                                  minDate: _minDate,
                                  maxDate: _maxDate,
                                  isRange: _isRange,
                                  selectDate: _currentDate,
                                  month: DateUtils.addMonthsToMonthDate(
                                    _minDate,
                                    _initialMonthIndex + index,
                                  ),
                                  onSelect: select,
                                ),
                                childCount:
                                    _numberOfMonths - _initialMonthIndex,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.showConfirm,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                  child: Column(
                    spacing: 8.0,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.presets != null)
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            ...?widget.presets?.entries.map(
                              (el) => ActionChip(
                                label: Text(el.key),
                                visualDensity: VisualDensity.compact,
                                labelStyle: theme.textTheme.labelSmall,
                                onPressed: () {
                                  onChange(el.value);
                                },
                              ),
                            ),
                          ],
                        ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: color,
                          minimumSize: Size.fromHeight(48.0),
                        ),
                        onPressed:
                            (_isRange
                                    ? _currentDate.length == 2
                                    : _currentDate.isNotEmpty)
                                ? confirm
                                : null,
                        child: Text(widget.confirmText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
