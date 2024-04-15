import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = "330EA15F-EA66-4658-9BF5-2B7281ECA17D";
const coinBaseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=";

class exchangeRate {
  dynamic exchangeRateList = [];

  Future<List<dynamic>> getExhange(String currency) async {
    // var url = Uri.http("www.rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$apiKey");
    http.Response responseBtc = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$apiKey"));
    http.Response responseEth = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/exchangerate/ETH/$currency?apikey=$apiKey"));
    http.Response responseLtc = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/exchangerate/LTC/$currency?apikey=$apiKey"));
    var dataBtc = jsonDecode(responseBtc.body);
    var dataEth = jsonDecode(responseEth.body);
    var dataLtc = jsonDecode(responseLtc.body);
    exchangeRateList.addAll([dataBtc, dataEth, dataLtc]);

    return exchangeRateList;
  }
}
