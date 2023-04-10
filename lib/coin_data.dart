import 'package:bitcoin_ticker/services/networking.dart' as net;

const List<String> kCurrenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> kCryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  static Future<double?> getCoinExchangeRate(
      {required String baseCoin, required String targetCoin}) async {
    return await net.getCoinExchangeRate(
        baseCoin: baseCoin, targetCoin: targetCoin);
  }
}
