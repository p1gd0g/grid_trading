import 'package:grid_trading/enum/exchange.dart';

class BarData {
  final int timestamp;

  final double? open;

  final double? close;

  final double? low;

  final double? high;

  final double? volume; // 成交量

  final double? turnover; // 成交额

  DateTime get dt {
    _dt ??= DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return _dt!;
  }

  DateTime? _dt;

  BarData.fromJson(Map<String, dynamic> json)
    : timestamp = getTimestamp(json),
      open = getDouble(json, 'Open'),
      close = getDouble(json, 'Close'),
      low = getDouble(json, 'Low'),
      high = getDouble(json, 'High'),
      volume = getDouble(json, 'Volume'),
      turnover = getDouble(json, 'Turnover');

  static int getTimestamp(Map<String, dynamic> json) {
    var timestamp = json['Timestamp'];
    if (timestamp is int) {
      return timestamp;
    }

    timestamp = json['Date'] ?? json['Datetime'];
    if (timestamp is int) {
      return timestamp ~/ 1000;
    }
    var str = timestamp.toString();
    if (str.length > 10) {
      str = str.substring(0, 10);
    }
    return int.parse(str);
  }

  static double getDouble(Map<String, dynamic> json, String name) {
    var value = json[name];
    if (value == null) {
      return 0;
    }

    if (value is double) {
      return value;
    }

    return double.parse(value);
  }

  bool filterPauseTime(Exchange exchange) {
    if (exchange == .crypto || exchange == .us || exchange == .unknown) {
      return true;
    }

    // final pauseStartUtc = exchange == Exchange.hk
    //     ? 4 *
    //           3600 // UTC 04:00
    //     : 7 * 3600 + 30 * 60; // UTC 03:30
    // const pauseEndUtc = 5 * 3600; // UTC 05:00

    final DateTime pauseStart = exchange == Exchange.hk
        ? dt
              .toUtc()
              .copyWith(
                hour: 4,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              )
              .toLocal()
        : dt
              .toUtc()
              .copyWith(
                hour: 3,
                minute: 30,
                second: 0,
                millisecond: 0,
                microsecond: 0,
              )
              .toLocal();

    final DateTime pauseEnd = dt
        .toUtc()
        .copyWith(hour: 5, minute: 0, second: 0, millisecond: 0, microsecond: 0)
        .toLocal();

    // final utcSecondsOfDay = timestamp % 86400;
    // return !(utcSecondsOfDay > pauseStartUtc && utcSecondsOfDay < pauseEndUtc);

    return !(dt.isAfter(pauseStart) && dt.isBefore(pauseEnd));
  }
}
