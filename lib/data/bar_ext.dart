import 'package:grid_trading/data/bar.dart';
import 'package:grid_trading/enum/exchange.dart';

extension ChartSampleDataExtension on List<BarData> {
  // 过滤掉中午休市时间段的数据
  List<BarData> filterPauseTime(Exchange exchange) {
    if (exchange == .crypto || exchange == .us || exchange == .unknown) {
    } else {
      return this;
    }

    final pauseStartUtc = exchange == Exchange.hk
        ? 4 *
              3600 // UTC 04:00
        : 7 * 3600 + 30 * 60; // UTC 03:30
    const pauseEndUtc = 5 * 3600; // UTC 05:00

    return where((e) {
      final utcSecondsOfDay = e.timestamp % 86400;
      return !(utcSecondsOfDay > pauseStartUtc &&
          utcSecondsOfDay < pauseEndUtc);
    }).toList();
  }

  Duration calcInterval() {
    if (length < 2) {
      return Duration.zero;
    }
    var secs = (this[1].timestamp - this[0].timestamp);
    return Duration(seconds: secs);
  }

  String calcIntervalStr() {
    var interval = calcInterval();
    if (interval.inSeconds < 60) {
      return '${interval.inSeconds} 秒';
    } else if (interval.inMinutes < 60) {
      return '${interval.inMinutes} 分钟';
    } else if (interval.inHours < 24) {
      return '${interval.inHours} 小时';
    } else {
      return '${interval.inDays} 天';
    }
  }

  Duration getPeriod() {
    if (isEmpty) {
      return Duration.zero;
    }

    var start = firstOrNull?.timestamp;
    var end = lastOrNull?.timestamp;
    if (start == null || end == null) {
      return Duration.zero;
    }

    return Duration(seconds: end - start);
  }
}
