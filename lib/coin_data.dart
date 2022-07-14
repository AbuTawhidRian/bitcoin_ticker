import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
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

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const bitcoinAverageURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '9F56E056-6B4D-4D4E-8AA2-66185591021C';

class CoinData {
  Future<dynamic> getCoinData(String selectCurrency) async {
    Map<String, String> cryptoPrice = {};
    for (String crypto in cryptoList) {
      String requestURL =
          '$bitcoinAverageURL/$crypto/$selectCurrency?apiKey=$apiKey';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrice[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrice;
  }
}
