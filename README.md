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

Library Usage:
===============
* Cache + Menu + Server:
You need to add the following to your main, to configure the cache and start the menu/server:
```
import 'package:dart_worker/ccserver.dart';

main(List<String> arguments){
  
  bool menu = true;
  /// add -server to startup for standalone server
  if(arguments.length != 0){
     if(arguments[0] == "-server"){   
      menu = false;
    } 
  }
  
  var srvConfig = new Map();
  ///// HTTP Server Setup
  srvConfig["server_ip"] = "127.0.0.1";
  srvConfig["server_port"] = 4042;
  ///// Mongo Config
  srvConfig["mongo_ip"] = "127.0.0.1";
  srvConfig["mongo_port"] = "27017";
  srvConfig["mongo_table"] = "";
  srvConfig["mongo_user"] ="";
  srvConfig["mongo_pass"] = "";
  ///// Start Server
  var server = new ccServer(menu, srvConfig);
}
```
* Objects:
```
daeObj() - Daemon Object

dbObj() - MySQL Database Object

wallet() - Wallet Object
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