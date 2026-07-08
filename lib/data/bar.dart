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
      open = _getDoubleFromMap(json, ['Open', 'open']),
      close = _getDoubleFromMap(json, ['Close', 'close']),
      low = _getDoubleFromMap(json, ['Low', 'low']),
      high = _getDoubleFromMap(json, ['High', 'high']),
      volume = _getDoubleFromMap(json, ['Volume', 'volume']),
      turnover = _getDoubleFromMap(json, ['Turnover', 'amount']);

  static int getTimestamp(Map<String, dynamic> json) {
    var timestamp = json['Timestamp'];
    if (timestamp is int) {
      return timestamp;
    }

    timestamp = json['Date'] ?? json['Datetime'] ?? json['datetime'];
    if (timestamp is int) {
      return timestamp ~/ 1000;
    }
    var str = timestamp.toString();
    if (str.length > 10) {
      str = str.substring(0, 10);
    }
    return int.parse(str);
  }

  static double _getDoubleFromMap(
    Map<String, dynamic> json, [
    List<String> names = const [],
  ]) {
    dynamic value;
    for (var name in names) {
      value = json[name];
      if (value != null) {
        break;
      }
    }
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

    return !(dt.isAfter(pauseStart) && dt.isBefore(pauseEnd));
  }
}
