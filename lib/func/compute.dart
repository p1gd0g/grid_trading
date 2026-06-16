import 'package:grid_trading/data/bar.dart';
import 'package:grid_trading/data/transaction.dart';

// 模拟交易，计算触发次数
int compute(List<BarData> bars, double priceRange) {
  var count = 0;

  var tmpBasePrice = bars.firstOrNull?.open ?? 0;

  if (tmpBasePrice == 0) {
    return 0;
  }

  for (var i = 0; i < bars.length; i++) {
    var bar = bars[i];

    var trans = Transaction(
      priceRangeType: .price,
      tradeType: .byAmount,
      isT0: true,
      upCountOrValue: 1,
      downCountOrValue: 1,
      tmpUpPrice: priceRange,
      tmpDownPrice: priceRange,
    );

    tmpBasePrice = trans.checkOpen(bar, tmpBasePrice);
    tmpBasePrice = trans.checkHigh(bar, tmpBasePrice);
    tmpBasePrice = trans.checkLow(bar, tmpBasePrice);
    tmpBasePrice = trans.checkClose(bar, tmpBasePrice);

    count += trans.transDeals.length;
  }

  return count;
}
