class BarData {
  final int timestamp;

  final double? open;

  final double? close;

  final double? low;

  final double? high;

  final double? volume;

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
      volume = getDouble(json, 'Volume');

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
    if (value is double) {
      return value;
    }

    return double.parse(value);
  }
}
