import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/exchange.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:http/http.dart' as http;

const apiKey = "330EA15F-EA66-4658-9BF5-2B7281ECA17D";
const coinBaseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=";

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = "USD";
  var exchangeRateData;
// dynamic exchangeRateList = [];
  List<dynamic> exchangeData = [];

  Map btc = {};
  Map eth = {};
  Map ltc = {};
  // exchangeRate getExchangeRate = exchangeRate();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeExchange(selectedCurrency ?? "USD");
  }

//    getExhange(String currency) async {
//     var data = await getExchangeRate.getExhange(currency);

// // print(data);

//     exchangeRateData = data;
//     // print(exchangeRateData);
//     btc = exchangeRateData[0];
//     eth = exchangeRateData[1];
//     ltc = exchangeRateData[2];
//    return data;
//   }

  void initializeExchange(String currency) async {
    exchangeRate exchangeList = exchangeRate();
    List<dynamic> data = await exchangeList.getExhange(currency);
    setState(() {
      exchangeData.addAll(data);
      btc = exchangeData[0];
      eth = exchangeData[1];
      ltc = exchangeData[2];
    });
  }

// ANDROID DROPDOWN
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          initializeExchange(selectedCurrency!);
        });
      },
      value: selectedCurrency,
    );
  }

  // iOS DROPDOWN
  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      itemExtent: 34.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (value) {
        // print(value);
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return androidDropdown();
    } else if (Platform.isIOS) {
      return iosPicker();
    } else {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(btc);
    // print(exchangeRateData);
    // print(exchangeRateList);
    print(exchangeData);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CardCoin(
            coin: btc["asset_id_base"],
            currency: btc["asset_id_quote"],
            exachangeRate: btc["rate"],
          ),
          CardCoin(
            coin: eth["asset_id_base"],
            currency: eth["asset_id_quote"],
            exachangeRate: eth["rate"],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: CardCoin(
              coin: ltc["asset_id_base"],
              currency: ltc["asset_id_quote"],
              exachangeRate: ltc["rate"],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CardCoin extends StatelessWidget {
  CardCoin({super.key, this.currency, this.coin, this.exachangeRate});

  String? currency;
  String? coin;
  double? exachangeRate;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $coin = ${exachangeRate!.round()} $currency',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
