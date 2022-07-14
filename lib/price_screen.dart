import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  bool isLoading = true;
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //6: Update the default currency to AUD, the first item in the currencyList.
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          //2: Call getData() when the picker/dropdown changes.
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          //1: Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          //2: Call getData() when the picker/dropdown changes.
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      //We're now passing the selectedCurrency when we call getCoinData().
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCard(
                  cryptoCurrency: 'BTC',
                  pad: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                  bitcoinValue: isWaiting ? '?' : coinValues['BTC'].toString(),
                  selectedCurrency: selectedCurrency),
              CustomCard(
                  cryptoCurrency: 'ETH',
                  pad: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 0),
                  bitcoinValue: isWaiting ? '?' : coinValues['ETH'].toString(),
                  selectedCurrency: selectedCurrency),
              CustomCard(
                  cryptoCurrency: 'LTC',
                  pad: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 0),
                  bitcoinValue: isWaiting ? '?' : coinValues['LTC'].toString(),
                  selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.pad,
    required this.bitcoinValue,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  }) : super(key: key);

  final EdgeInsetsGeometry pad;
  final String bitcoinValue;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pad,
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            //5: Update the currency name depending on the selectedCurrency.
            '1 $cryptoCurrency = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
