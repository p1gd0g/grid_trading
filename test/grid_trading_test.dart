import 'package:flutter_test/flutter_test.dart';

import 'package:grid_trading/grid_trading.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });

  test('duration', () {
    expect(Duration(seconds: 1).toString(), '0:00:01.000000');
  });
}
