import 'package:intl/intl.dart';

class DateUtil {
  DateUtil._();

  /// 计算两个日期相差多少年
  static int daysBetweenYear(DateTime a, DateTime b) {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    return v ~/ 86400000 * 30 * 12;
  }

  /// 计算两个日期相差多少月
  static int daysBetweenMonth(DateTime a, DateTime b) {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    return v ~/ 86400000 * 30;
  }

  /// 计算两个日期相差多少天
  static int daysBetweenDay(DateTime a, DateTime b) {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    return v ~/ 86400000;
  }

  /// 计算两个日期相差多少分钟
  static int daysBetweenMin(DateTime a, DateTime b) {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    return v ~/ 60000;
  }

  /// 计算两个日期相差多少秒
  static int daysBetweenSecond(DateTime a, DateTime b) {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    return v ~/ 1000;
  }

  /// 计算两个日期相差多少毫秒
  static int daysBetweenMillSecond(DateTime a, DateTime b) {
    int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
    return v;
  }

  /// 获取当天（不足两位，拼0处理）space 需要拼接日期的字段
  static String getYYYYMMDD(DateTime dateTime, String space) {
    String year = dateTime.year.toString();
    String month =
        dateTime.month.toString().length == 1
            ? "0${dateTime.month}"
            : dateTime.month.toString();
    String day =
        dateTime.day.toString().length == 1
            ? "0${dateTime.day}"
            : dateTime.day.toString();
    return "$year$space$month$space$day";
  }

  /// 获取当天（不足两位，拼0处理）* space 需要拼接日期的字段
  static String getYYYYMMDDHHMMSS(DateTime dateTime, String space) {
    String year = dateTime.year.toString();
    String month =
        dateTime.month.toString().length == 1
            ? "0${dateTime.month}"
            : dateTime.month.toString();
    String day =
        dateTime.day.toString().length == 1
            ? "0${dateTime.day}"
            : dateTime.day.toString();
    String hour =
        dateTime.hour.toString().length == 1
            ? "0${dateTime.hour}"
            : dateTime.hour.toString();
    String minute =
        dateTime.minute.toString().length == 1
            ? "0${dateTime.minute}"
            : dateTime.minute.toString();
    String second =
        dateTime.second.toString().length == 1
            ? "0${dateTime.second}"
            : dateTime.second.toString();
    return "$year$space$month$space$day $hour$space$minute$space$second";
  }

  /// 获取昨天
  static String getYesterDayYYYYMMDD(DateTime dateTime) {
    DateTime yesterDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch - (24 * 60 * 60 * 1000),
    );
    return getYYYYMMDD(yesterDay, "-");
  }

  /// 获取前天
  static String getDayBeforeYesterdayDayYYYYMMDD(DateTime dateTime) {
    DateTime yesterDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch - (2 * 24 * 60 * 60 * 1000),
    );
    return getYYYYMMDD(yesterDay, "-");
  }

  /// 获取明天
  static String getTomorrowDayYYYYMMDD(DateTime dateTime) {
    DateTime yesterDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch + (24 * 60 * 60 * 1000),
    );
    return getYYYYMMDD(yesterDay, "-");
  }

  /// 获取后天
  static String getTomorrowAcquiredYYYYMMDD(DateTime dateTime) {
    DateTime yesterDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch + (2 * 24 * 60 * 60 * 1000),
    );
    return getYYYYMMDD(yesterDay, "-");
  }

  /// 获取本周开始
  static String getWeekFirstDayYYYYMMDD(DateTime dateTime) {
    int current = dateTime.weekday;
    DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch - (24 * 60 * 60 * 1000 * (current - 1)),
    );
    return getYYYYMMDD(firstDay, "-");
  }

  /// 获取本周结束
  static String getWeekLastDayYYYYMMDD(DateTime dateTime) {
    int current = dateTime.weekday;
    DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch + (24 * 60 * 60 * 1000 * (7 - current)),
    );
    return getYYYYMMDD(lastDay, "-");
  }

  /// 获取上周开始
  static String getLastWeekFirstDayYYYYMMDD(DateTime dateTime) {
    int current = dateTime.weekday;
    DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch - (24 * 60 * 60 * 1000 * (current - 1)),
    );
    DateTime day = DateTime.fromMillisecondsSinceEpoch(
      firstDay.millisecondsSinceEpoch - (24 * 60 * 60 * 1000 * 7),
    );
    return getYYYYMMDD(day, "-");
  }

  /// 获取上周结束
  static String getLastWeekLastDayYYYYMMDD(DateTime dateTime) {
    int current = dateTime.weekday;
    DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(
      dateTime.millisecondsSinceEpoch + (24 * 60 * 60 * 1000 * (7 - current)),
    );
    DateTime day = DateTime.fromMillisecondsSinceEpoch(
      lastDay.millisecondsSinceEpoch - (24 * 60 * 60 * 1000 * 7),
    );
    return getYYYYMMDD(day, "-");
  }

  /// 获取本月第一天
  static String getMonthFirstDayYYYYMMDD(DateTime dateTime, String space) {
    String year = "${DateTime.now().year}";
    String month =
        "${DateTime.now().month}".length == 1
            ? "0${DateTime.now().month}"
            : "${DateTime.now().month}";
    return "$year$space$month${space}01";
  }

  /// 获取本月最后一天
  static String getMonthLastDayYYYYMMDD(DateTime dateTime, String space) {
    String year = "${DateTime.now().year}";
    String month =
        "${DateTime.now().month}".length == 1
            ? "0${DateTime.now().month}"
            : "${DateTime.now().month}";
    int d = getDayCounts(DateTime.now().month);
    return "$year$space$month$space$d";
  }

  /// 获取周几
  static String? getWeekday(DateTime? dateTime) {
    if (dateTime == null) return null;
    String weekday = switch (dateTime.weekday) {
      1 => '星期一',
      2 => '星期二',
      3 => '星期三',
      4 => '星期四',
      5 => '星期五',
      6 => '星期六',
      7 => '星期日',
      _ => '',
    };
    return weekday;
  }

  /// 获取一个月有多少天
  static int getDayCounts(int month) {
    int year = DateTime.now().year;

    int end = switch (month) {
      1 => 31,
      2 => (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0) ? 29 : 28,
      3 => 31,
      4 => 30,
      5 => 31,
      6 => 30,
      7 => 31,
      8 => 31,
      9 => 30,
      10 => 31,
      11 => 30,
      12 => 31,
      _ => 0,
    };

    return end;
  }

  /// 获取本周
  static List<String> getThisWeek(DateTime date) {
    int current = date.weekday;
    DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(
      date.millisecondsSinceEpoch - (24 * 60 * 60 * 1000 * (current - 1)),
    );
    DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(
      date.millisecondsSinceEpoch + (24 * 60 * 60 * 1000 * (7 - current)),
    );
    return [
      DateFormat('yyyy-MM-dd').format(firstDay),
      DateFormat('yyyy-MM-dd').format(lastDay),
    ];
  }

  /// 获取上周
  static List<String> getLastWeek(DateTime date) {
    int current = date.weekday;
    DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(
      date.millisecondsSinceEpoch -
          (24 * 60 * 60 * 1000 * (current - 1)) -
          (24 * 60 * 60 * 1000 * 7),
    );

    DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(
      date.millisecondsSinceEpoch +
          (24 * 60 * 60 * 1000 * (7 - current)) -
          (24 * 60 * 60 * 1000 * 7),
    );

    return [
      DateFormat('yyyy-MM-dd').format(firstDay),
      DateFormat('yyyy-MM-dd').format(lastDay),
    ];
  }

  /// 获取下周
  static List<String> getNextWeek(DateTime date) {
    // 当前周的周一
    final thisWeekMonday = date.subtract(Duration(days: date.weekday - 1));
    // 下周周一
    final nextWeekMonday = thisWeekMonday.add(Duration(days: 7));
    final nextWeekStart = DateTime(
      nextWeekMonday.year,
      nextWeekMonday.month,
      nextWeekMonday.day,
    );

    final nextWeekSunday = nextWeekStart.add(Duration(days: 6));
    return [
      DateFormat('yyyy-MM-dd').format(nextWeekStart),
      DateFormat('yyyy-MM-dd').format(nextWeekSunday),
    ];
  }

  /// 获取本月
  static List<String> getThisMonth(DateTime date) {
    int year = date.year, month = date.month;

    return [
      DateFormat('yyyy-MM-dd').format(DateTime(year, month, 1)),
      DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1, 0)),
    ];
  }

  /// 获取上月
  static List<String> getLastMonth(DateTime date) {
    int year = date.year, month = date.month;

    return [
      DateFormat('yyyy-MM-dd').format(DateTime(year, month - 1, 1)),
      DateFormat('yyyy-MM-dd').format(DateTime(year, month, 0)),
    ];
  }

  /// 获取本月-截止当天
  static List<String> getCurMonth(DateTime date) {
    int year = date.year, month = date.month, day = date.day;

    return [
      DateFormat('yyyy-MM-dd').format(DateTime(year, month, 1)),
      DateFormat('yyyy-MM-dd').format(DateTime(year, month, day)),
    ];
  }

  /// 获取下月
  static List<String> getNextMonth(DateTime date) {
    // 下月第一天
    final nextMonthStart = DateTime(date.year, date.month + 1, 1);
    // 下月最后一天 = 下下月第一天 - 1 天
    final nextMonthEnd = DateTime(
      nextMonthStart.year,
      nextMonthStart.month + 1,
      1,
    ).subtract(Duration(days: 1));
    return [
      DateFormat('yyyy-MM-dd').format(nextMonthStart),
      DateFormat('yyyy-MM-dd').format(nextMonthEnd),
    ];
  }
}
