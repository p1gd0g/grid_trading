import 'package:grid_trading/data/bar.dart';
import 'package:grid_trading/data/transaction_deal.dart';
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

  List<TransactionDeal> transDeals = [];

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

  double checkOpen(BarData bar, double tmpBasePrice) {
    if (bar.open! > tmpBasePrice) {
      var triggerSellPrice = nextTriggerSellPrice(tmpBasePrice, tmpUpPrice);
      while (bar.open! >= triggerSellPrice) {
        transDeals.add(TransactionDeal()..price = bar.open!);
        tmpBasePrice = triggerSellPrice;
        triggerSellPrice = nextTriggerSellPrice(tmpBasePrice, tmpUpPrice);
      }
    } else if (bar.open! < tmpBasePrice) {
      var triggerBuyPrice = nextTriggerBuyPrice(tmpBasePrice, tmpDownPrice);
      while (bar.open! <= triggerBuyPrice) {
        transDeals.add(TransactionDeal()..price = bar.open!);
        tmpBasePrice = triggerBuyPrice;
        triggerBuyPrice = nextTriggerBuyPrice(tmpBasePrice, tmpDownPrice);
      }
    }
    return tmpBasePrice;
  }

  double checkHigh(BarData bar, double tmpBasePrice) {
    var triggerSellPrice = nextTriggerSellPrice(tmpBasePrice, tmpUpPrice);
    while (bar.high! >= triggerSellPrice) {
      transDeals.add(TransactionDeal()..price = triggerSellPrice);
      tmpBasePrice = triggerSellPrice;
      triggerSellPrice = nextTriggerSellPrice(tmpBasePrice, tmpUpPrice);
    }
    return tmpBasePrice;
  }

  double checkLow(BarData bar, double tmpBasePrice) {
    var triggerBuyPrice = nextTriggerBuyPrice(tmpBasePrice, tmpDownPrice);
    while (bar.low! <= triggerBuyPrice) {
      transDeals.add(TransactionDeal()..price = triggerBuyPrice);
      tmpBasePrice = triggerBuyPrice;
      triggerBuyPrice = nextTriggerBuyPrice(tmpBasePrice, tmpDownPrice);
    }
    return tmpBasePrice;
  }

  double checkClose(BarData bar, double tmpBasePrice) {
    if (bar.close! > tmpBasePrice) {
      var triggerSellPrice = nextTriggerSellPrice(tmpBasePrice, tmpUpPrice);
      while (bar.close! >= triggerSellPrice) {
        transDeals.add(TransactionDeal()..price = triggerSellPrice);
        tmpBasePrice = triggerSellPrice;
        triggerSellPrice = nextTriggerSellPrice(tmpBasePrice, tmpUpPrice);
      }
    } else if (bar.close! < tmpBasePrice) {
      var triggerBuyPrice = nextTriggerBuyPrice(tmpBasePrice, tmpDownPrice);
      while (bar.close! <= triggerBuyPrice) {
        transDeals.add(TransactionDeal()..price = triggerBuyPrice);
        tmpBasePrice = triggerBuyPrice;
        triggerBuyPrice = nextTriggerBuyPrice(tmpBasePrice, tmpDownPrice);
      }
    }
    return tmpBasePrice;
  }
}
