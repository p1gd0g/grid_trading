import 'package:grid_trading/data/bar.dart';
import 'package:grid_trading/enum/exchange.dart';

extension ChartSampleDataExtension on List<BarData> {
  // 过滤掉中午休市时间段的数据
  List<BarData> filterClose(Exchange exchange) {
    if (exchange == .crypto || exchange == .us || exchange == .unknown) {
    } else {
      return this;
    }

    return where((e) {
      final dateTime = e.dt;
      final pauseEnd = DateTime.utc(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        5,
        0,
      );

      if (exchange == Exchange.hk) {
        final pauseStart = DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          4,
          0,
        ).add(const Duration(hours: 8));
        if (dateTime.isAfter(pauseStart) && dateTime.isBefore(pauseEnd)) {
          return false;
        }
      } else {
        final pauseStart = DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          3,
          30,
        ).add(const Duration(hours: 8));
        if (dateTime.isAfter(pauseStart) && dateTime.isBefore(pauseEnd)) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}
