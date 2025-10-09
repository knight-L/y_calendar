import 'package:flutter/material.dart';

import 'y_flitter_date.dart';
import 'y_month_Item.dart';
import 'y_top.dart';

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
  final bool? cumFlitter;

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
    this.cumFlitter,
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
    if (widget.defaultDate != null) {
      _currentDate =
          _isRange
              ? widget.defaultDate as List<DateTime>
              : [widget.defaultDate as DateTime];
    }
    _minDate = widget.minDate ?? dateOnly;
    _maxDate = widget.maxDate ?? dateOnly.add(const Duration(days: 180));

    onChange();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onChange() {
    _initialMonthIndex = DateUtils.monthDelta(
      _minDate,
      _currentDate.isNotEmpty ? _currentDate.first : dateOnly,
    );
    if (_currentDate.isEmpty) return;

    if (_isRange) {
      for (var el in _currentDate) {
        var newEl = DateUtils.dateOnly(el);
        el = newEl.isAfter(_maxDate) ? _maxDate : newEl;
      }
    } else {
      _currentDate = [_currentDate.first];
    }
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
                      child: Container(
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
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: widget.cumFlitter ?? false,
                        child: YFlitterDate(
                          onChange: (val) {
                            setState(() {
                              _currentDate =
                                  val.map((e) => DateTime.parse(e)).toList();
                              onChange();
                            });
                          },
                        ),
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
