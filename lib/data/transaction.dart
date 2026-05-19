import 'package:grid_trading/enum/price_range_type.dart';
import 'package:grid_trading/enum/trade_type.dart';

class Transaction {
  final PriceRangeType priceRangeType;
  final TradeType tradeType;
  final bool isT0;
  final double upCountOrValue;
  final double downCountOrValue;
  final double tmpUpPrice;
  final double tmpDownPrice;

  Transaction({
    required this.priceRangeType,
    required this.tradeType,
    required this.isT0,
    required this.upCountOrValue,
    required this.downCountOrValue,
    required this.tmpUpPrice,
    required this.tmpDownPrice,
  });

  double nextTriggerSellPrice(double tmpPrice, double upPrice) {
    if (priceRangeType == PriceRangeType.percent) {
      return tmpPrice * (1 + upPrice);
    }
    return tmpPrice + upPrice;
  }

  double nextTriggerBuyPrice(double tmpPrice, double upPrice) {
    if (priceRangeType == PriceRangeType.percent) {
      return tmpPrice * (1 - upPrice);
    }
    return tmpPrice - upPrice;
  }
}
