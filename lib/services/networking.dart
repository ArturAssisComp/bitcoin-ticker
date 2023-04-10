import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/constants.dart';
import 'dart:convert';

//constants:
const String _kCoinApiAuthority = 'rest.coinapi.io';
const String _kCoinApiPathPrefix = '/v1/exchangerate';
const String _kCoinApiKey = String.fromEnvironment('COIN_API_KEY');

const Map<String, String> _kCoinApiParameters = {
  'apikey': _kCoinApiKey,
};

Future<double?> getCoinExchangeRate(
    {required String baseCoin, required String targetCoin}) async {
  StringBuffer completePath = StringBuffer(_kCoinApiPathPrefix);
  completePath.writeAll(['/', baseCoin, '/', targetCoin]);
  Uri url = Uri.https(
    _kCoinApiAuthority,
    completePath.toString(),
    _kCoinApiParameters,
  );

  http.Response response = await http.get(url);
  if (response.statusCode == kHttpSuccess) {
    final jsonResult = jsonDecode(response.body);
    try {
      final tmp = jsonResult['rate'];
      if (tmp is String) {
        return double.parse(tmp);
      } else if (tmp is double) {
        return tmp;
      }
    } catch (_) {}
  }
  return null;
}
