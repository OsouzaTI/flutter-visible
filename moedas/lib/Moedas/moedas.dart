
class Moedas {

  String code;
  String codein;
  String name;
  String high;
  String low;
  String varbid;
  String pctChange;
  String bid;
  String ask;
  String timestamp;
  String createdate;

  List<String> todasMoedas = [
    "USD",
    "USDT",
    "CAD",
    "EUR",
    "GBP",
    "ARS",
    "BTC",
    "LTC",
    "JPY",
    "CHF",
    "AUD",
    "CNY",
    "ILS"
  ];

  Moedas(){
    code        = '';
    codein      = '';
    name        = '';
    high        = '';
    low         = '';
    varbid      = '';
    pctChange   = '';
    bid         = '';
    ask         = '';
    timestamp   = '';
    createdate  = '';
  }
  
  Moedas.fromJson(Map<String, dynamic> json){
    code      = json['code'] ?? '';
    codein    = json['codein'] ?? '';
    name      = json['name'] ?? '';
    high      = json['high'] ?? '';
    low       = json['low'] ?? '';
    varbid    = json['varbid'] ?? '';
    pctChange = json['pctChange'] ?? '';
    bid       = json['bid'] ?? '';
    ask       = json['ask'] ?? '';
    timestamp = json['timestamp'] ?? '';
    createdate = json['create_date'] ?? '';
  }

}