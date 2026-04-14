import 'package:grid_trading/data/bar.dart';
import 'package:grid_trading/enum/exchange.dart';

extension ChartSampleDataExtension on List<BarData> {
  
  // 过滤掉中午休市时间段的数据
  List<BarData> filterPauseTime(Exchange exchange) {
    return where((e) => e.filterPauseTime(exchange)).toList();
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
