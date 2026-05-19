import 'package:grid_trading/enum/price_range_type.dart';
import 'package:grid_trading/enum/trade_type.dart';

class Transaction {
  final PriceRangeType priceRangeType;
  final TradeType tradeType;

  Transaction({required this.priceRangeType, required this.tradeType});

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
