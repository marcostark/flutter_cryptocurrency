import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() async{

  List currencies = await getListCoin();

  runApp(new MaterialApp(
    home: CryptoListWidget(currencies)
  ));
}

//Future<List> getListCoin() async {
//  String api = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
//
//  http.Response response = await http.get(api);
//
//  if(response.statusCode == 200) {
//    List coins = json.decode(response.body);
//    return coins.map((coin) => Coin.fromJson(coin)).toList();
//  } else {
//    throw Exception('Falha ao carregar a lista');
//  }
//}

Future<List> getListCoin() async {
  String apiUrl = 'https://api.coinmarketcap.com/v1/ticker/?limit=25';
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}

class CryptoListWidget extends StatelessWidget {

  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];
  // Lista contendo todos os dados retornado pela api
  final List _currencies;



  CryptoListWidget(this._currencies);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Criptomoedas',
      theme: ThemeData.light(),
      home: new Scaffold(
        appBar: AppBar(title: Text('Criptomoedas')),
        body: _buildBody(),
        //backgroundColor: Colors.blue,
        floatingActionButton: new FloatingActionButton(onPressed: (){
      },
        child: new Icon(Icons.add_alert),
      ),
      ),
    );
  }

  Widget _buildBody(){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0),
      child: new Column(
        children: <Widget>[
          //_getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _getListViewWidget() {

    return new Flexible(
      child: new ListView.builder(

        // Numero de itens a serem exibidos
        itemCount: _currencies.length,

        itemBuilder: (context, index){

          // Pegando a posição da moeda
          final Map currency = _currencies[index];

          final MaterialColor color = _colors[index % _colors.length];

          return _getListItemWidget(currency, color);
        }
      )
    );
  }

  Container _getSymbolWidget(String currencySymbol, MaterialColor color){
    return new Container (
        //padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Image.network('https://res.cloudinary.com/dxi90ksom/image/upload/${currencySymbol}'),
        width:56.0,
        height: 56.0,
    );
  }

//  CircleAvatar _getLeadinWidget(String currencySymbol, MaterialColor color){
//    return new CircleAvatar(
//      //backgroundColor: color,
//      //child: new Text(currencyName[0]),
//      child: Image.network('https://res.cloudinary.com/dxi90ksom/image/upload/${currencySymbol}')
//    );
//  }

  Text _getTitleWidget(String symbol, String currencyName) {
    return new Text(
      '${symbol} | ${currencyName}',
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Text _getSubTitleWidget(String priceUsd, String percentChange1h) {
    return new Text(
        '\$${double.parse(priceUsd).toStringAsFixed(2)}\n'
            '1h: $percentChange1h%', style: TextStyle(color: getColor(percentChange1h)),
    );
  }

  Container _getListItemWidget(Map currency, MaterialColor color) {
    return new Container (
      margin: const EdgeInsets.only(top: 0.5),
      child: new Card(
        child: _getListTitle(currency, color),
      ),
    );
  }

  ListTile _getListTitle(Map currency, MaterialColor color) {
    //final aux = currency['symbol'];
    return new ListTile(
      leading: _getSymbolWidget(currency['symbol'], color),
      title: _getTitleWidget(currency['symbol'], currency['name']),
      subtitle: _getSubTitleWidget(
          currency['price_usd'],
          currency['percent_change_1h']),
      isThreeLine: true,
    );
  }

  getColor(String percentChange1h) {
    if(percentChange1h.contains("-"))
      return Colors.red;
    else
      return Colors.green;
  }



}