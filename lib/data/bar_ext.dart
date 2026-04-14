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
}
