# dart_worker

A dart port for CheckoutCrypto's multi-cryptocurrency worker.

Install:
```
sudo add-apt-repository ppa:hachre/dart
sudo apt-get update
sudo apt-get install darteditor dartsdk dartium pub git mongodb robomongo

git clone https://github.com/hutchgrant/dart-worker
cd ./dart-worker
pub get
```
Run:
```
dart main.dart 
note: you can launch server standalone for a service etc with:
dart main.dart -server
```

Local cache
==============
MongoDB config options are in the file ./dart-worker/bin/Cache.dart
You will need to create a new database and user.

Remote(or local) site and Database
==============
```
sudo apt-get install git drush phpmyadmint curl php5-curl apache2 mysql-server mysql-client


Follow instructions at drupal menu, install.
cd /var/www/site/sites/all/ && git clone https://github.com/CheckoutCrypto/site.git
git submodule init && git submodule update
Login as admin, enable all modules, fix configurations e.g. smtp, site config, theme settings, blocks, etc.
```
Detailed site instructions on CheckoutCrypto's site installation and configuration can be found in that repository's readme https://github.com/CheckoutCrypto/site

Library Usage:
===============
* Cache + Menu + Server:
You need to add the following to your main to retrieve from the cache, start the menu/server.
```
main(List<String> arguments) {

  bool menu = true;
  if(arguments.length != 0){
     if(arguments[0] == "-server"){
      menu = false;
    } 
  }
  
  var cache = new Cache();
  var daemons = new daeObjs();
  var db = new dbObj();
  String apikey = "";

  Future<daeObjs> daeFut() => new Future.value(cache.getCoins());
  Future<dbObj> dbFut() => new Future.value(cache.getDB());
  Future<String> prefFut() => new Future.value(cache.getPref());

  daeFut().then((daemons){
    dbFut().then((db){
      prefFut().then((value){
        apikey = value;
        if(menu == true){
          menuCntrl(db, daemons, value);
        }else{
          var server = new Server(db, daemons, apikey);
        }
      });
    });
  });

```

* Objects:
```
daeObj() - Daemon Object

dbObj() - MySQL Database Object

wallet() - Wallet Object, for moving all the the wallet variables
```


Configure:
=============
```
CheckoutCrypto Menu
Options
1) Add remote DB
2) Add Rpc Coin
3) Generate Worker key
4) Start Server
```


1. Add a remote(CheckoutCrypto drupal site) DB to send the results of api queries</li>
2. Add each cryptocurrency RPC config information  
- Coin(short form)<
- RPC User
- RPC Password
- RPC Server
- RPC Port
- fee(host's service) + txfee
- Rate(set by cron later)
- Max Confirmation - The confirm at which a trade, deposit, withdrawal, is made
- Enable/Disable(true/false) 
3. Generate an API key
4. Start the HTTP Server - Set IP and port in ./lib/server.dart


Client
===========

Calls should be made from an authenticated front end api, utilizing a POST request to the dart-worker, accompanied by the worker's generated API key(see above). 

Connect to the Server using a client POST function similar to this:
```
String url = "http://127.0.0.1:4042"
request = new HttpRequest();
request.onReadyStateChange.listen(onData);
request.open('POST', url);
request.send('{"apikey":"$apikey", "coin":"BTC", "action":"getnewaddress", "params":{"uid":1, "account":"fee", "address":"", "recipient":"", "amount":""} }');
```
