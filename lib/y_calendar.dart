import 'package:flutter/material.dart';
import 'package:y_calendar/y_flitter_date.dart';

import 'y_month_title.dart';
import 'y_title.dart';
import 'y_weekdays.dart';

Future<T?> showYCalendar<T>({
  required BuildContext context,
  DateTimeRange? initialDateRange,
  DateTime? minDate,
  DateTime? maxDate,
  bool? cumFlitter,
  T? defaultDate,
}) async {
  assert(
    T == DateTime || T == List<DateTime>,
    'T 只能是 DateTime 或 List<DateTime>，但传入的是 $T',
  );
  assert(initialDateRange == null, 'initialDateRange 不能为空');
  assert(
    initialDateRange == null ||
        !initialDateRange.start.isAfter(initialDateRange.end),
    "开始时间不能小于结束时间",
  );
  if (minDate != null && maxDate != null) {
    minDate = DateUtils.dateOnly(minDate);
    maxDate = DateUtils.dateOnly(maxDate);
    assert(
      !maxDate.isBefore(minDate),
      'maxDate $maxDate 必须在 minDate $minDate 之后',
    );
  }
  assert(debugCheckHasMaterialLocalizations(context));

  if (initialDateRange != null) {
    initialDateRange = DateUtils.datesOnly(initialDateRange);
  }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder:
        (BuildContext context) => YCalendar<T>(
          minDate: minDate,
          maxDate: maxDate,
          defaultDate: defaultDate,
          cumFlitter: cumFlitter,
          color: Theme.of(context).primaryColor,
        ),
  );
}

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
  final dynamic defaultDate;

  // 日期行高
  final double rowHeight;

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

  // 日期选择完成后触发
  final ValueChanged<T>? onConfirm;

  const YCalendar({
    super.key,
    this.title = "日期选择",
    this.color = const Color(0xff1989fa),
    this.minDate,
    this.maxDate,
    this.defaultDate,
    this.rowHeight = 60.0,
    this.round = const BorderRadius.vertical(top: Radius.circular(20.0)),
    this.showConfirm = true,
    this.closeOnClickOverlay = true,
    this.confirmText = "确定",
    this.height = 400.0,
    this.cumFlitter,
    this.onConfirm,
  });

  @override
  State<YCalendar> createState() => _CalendarState<T>();
}

class _CalendarState<T> extends State<YCalendar<T>> {
  late List<DateTime> _defaultDate;
  late DateTime _currentDate;
  late DateTime _minDate;
  late DateTime _maxDate;
  DateTime? _startDate;
  DateTime? _endDate;
  final String _startString = "开始";
  final String _endString = "结束";
  bool _isRange = false;
  int _initialMonthIndex = 0;
  final DateTime dateOnly = DateUtils.dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    _isRange = T == List<DateTime>;
    _defaultDate = widget.defaultDate ?? [];
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
      _defaultDate.isNotEmpty ? _defaultDate.first : dateOnly,
    );
    if (_defaultDate.isEmpty) return;

    if (_isRange) {
      _startDate =
          DateUtils.dateOnly(_defaultDate.first).isAfter(_maxDate)
              ? _maxDate
              : DateUtils.dateOnly(_defaultDate.first);
      _endDate =
          DateUtils.dateOnly(_defaultDate.last).isAfter(_maxDate)
              ? _maxDate
              : DateUtils.dateOnly(_defaultDate.last);
    } else {
      _currentDate = _defaultDate.first;
    }
  }

  void close(BuildContext context, T date) {
    Navigator.pop(context, date);
  }

  Widget buildTop() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: widget.round,
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 0, // has the effect of extending the shadow
            offset: Offset(
              0, // horizontal, move right 10
              2, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[YTitle(title: widget.title), YWeekdays()],
      ),
    );
  }

  Widget buildCalendarItem(int year, int month, int day) {
    DateTime currentDate = DateTime(year, month, day);
    bool isEmpty = day < 1;
    bool isSelected =
        !_isRange && !isEmpty && DateUtils.isSameDay(currentDate, _currentDate);
    double dayItemWidth = (MediaQuery.of(context).size.width ~/ 7).toDouble();
    bool disable =
        currentDate.isBefore(DateUtils.dateOnly(_minDate)) ||
        currentDate.isAfter(DateUtils.dateOnly(_maxDate));

    bool isStart =
        _isRange ? DateUtils.isSameDay(currentDate, _startDate) : false;
    bool isEnd = _isRange ? DateUtils.isSameDay(currentDate, _endDate) : false;
    bool isCenter =
        (_isRange && _startDate != null && _endDate != null && !isEmpty) &&
        currentDate.isAfter(_startDate!) &&
        currentDate.isBefore(_endDate!);

    String info = "";
    BorderRadiusGeometry? borderRadius() {
      if (DateUtils.isSameDay(_startDate, _endDate)) {
        info =
            DateUtils.isSameDay(currentDate, _startDate)
                ? '$_startString/$_endString'
                : '';
        return BorderRadius.circular(4.0);
      } else if (isStart) {
        info = _startString;
        return const BorderRadius.horizontal(left: Radius.circular(4.0));
      } else if (isEnd) {
        info = _endString;
        return const BorderRadius.horizontal(right: Radius.circular(4.0));
      } else {
        info = "";
        return null;
      }
    }

    return SizedBox(
      width: dayItemWidth,
      height: widget.rowHeight,
      child: Visibility(
        visible: !isEmpty,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: borderRadius(),
              color:
                  isSelected || isStart || isEnd
                      ? widget.color
                      : isCenter
                      ? widget.color?.withAlpha((255 * 0.1).round())
                      : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap:
                  isEmpty || disable
                      ? null
                      : () {
                        setState(() {
                          if (_isRange) {
                            // 范围
                            if (_startDate == null ||
                                currentDate.isBefore(_startDate!) ||
                                _startDate != null && _endDate != null) {
                              _startDate = currentDate;
                              _endDate = null;
                            } else if (_startDate != null &&
                                _endDate == null &&
                                currentDate.difference(_startDate!).inDays >=
                                    0) {
                              _endDate = currentDate;
                            }

                            if (!widget.showConfirm &&
                                _startDate != null &&
                                _endDate != null) {
                              close(context, [_startDate!, _endDate!] as T);
                              widget.onConfirm?.call(
                                [_startDate, _endDate] as T,
                              );
                            }
                          } else {
                            // 单选
                            _currentDate = currentDate;
                            if (!widget.showConfirm) {
                              close(context, _currentDate as T);
                              widget.onConfirm?.call(_currentDate as T);
                            }
                          }
                        });
                      },
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        fontSize: 16.0,
                        color:
                            isSelected || isStart || isEnd
                                ? Colors.white
                                : isCenter
                                ? widget.color ?? const Color(0xff1989fa)
                                : disable
                                ? const Color(0xffc8c9cc)
                                : const Color(0xff323233),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.8),
                    child: Text(
                      info,
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
  }

  Widget buildConfirmButton() {
    bool disable =
        (!_isRange && _currentDate == null) ||
        (_isRange && (_startDate == null || _endDate == null));
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: widget.cumFlitter ?? false,
            child: YFlitterDate(
              onChange: (val) {
                setState(() {
                  _defaultDate = val.map((e) => DateTime.parse(e)).toList();
                  onChange();
                });
              },
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: widget.color),
            onPressed:
                disable
                    ? null
                    : () {
                      if (_startDate != null && _endDate != null) {
                        close(context, [_startDate!, _endDate!] as T);
                        widget.onConfirm?.call([_startDate!, _endDate!] as T);
                      } else if (_currentDate != null) {
                        close(context, _currentDate as T);
                        widget.onConfirm?.call(_currentDate as T);
                      }
                    },
            child: Text(widget.confirmText),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthItem(int index, bool beforeInitialMonth) {
    int monthIndex =
        beforeInitialMonth
            ? _initialMonthIndex - index - 1
            : _initialMonthIndex + index;
    DateTime month = DateUtils.addMonthsToMonthDate(_minDate, monthIndex);

    int currentYear = month.year;
    int currentMonth = month.month;

    int lastDay = DateTime(currentYear, currentMonth + 1, 0).day;
    int emptyDays = DateTime(currentYear, currentMonth, 1).weekday % 7;

    return IntrinsicHeight(
      child: Stack(
        children: <Widget>[
          // 背景
          Align(
            child: Text(
              "$currentMonth",
              style: const TextStyle(
                fontSize: 150.0,
                fontWeight: FontWeight.w500,
                color: Color(0xfff2f3f5),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              YMonthTitle(year: currentYear, month: currentMonth),
              Wrap(
                children: List.generate(lastDay + emptyDays, (i) {
                  int day = i - emptyDays + 1;
                  return buildCalendarItem(currentYear, currentMonth, day);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int get _numberOfMonths => DateUtils.monthDelta(_minDate, _maxDate) + 1;

  @override
  Widget build(BuildContext context) {
    const Key sliverAfterKey = Key('sliverAfterKey');

    return AspectRatio(
      aspectRatio: 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.round,
          color: Theme.of(context).cardColor,
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    buildTop(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomScrollView(
                          center: sliverAfterKey,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    _buildMonthItem(index, true),
                                childCount: _initialMonthIndex,
                              ),
                            ),
                            SliverList(
                              key: sliverAfterKey,
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    _buildMonthItem(index, false),
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
                child: buildConfirmButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
