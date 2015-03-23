#CheckoutCrypto Dart Worker

A dart port for CheckoutCrypto's multi-cryptocurrency worker.

##Git Install:
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

Post-Install
You need a CheckoutCrypto Site and your own custom client. No official, dart-worker, api, client, released yet. This port is still in early development. 

##Docker install 

###Pre-install and run MongoDB daemon container with mysql connection

```
 sudo docker run -it -d --name mongo dockerfile/mongodb
```

###Add table and user (need latest docker)

```
sudo docker exec -it mongo /bin/bash
mongo
db.createCollection("bitcoin")
use bitcoin
db.createUser(
  {
    user: "test",
    pwd: "testpass",
    roles: [ { role: "userAdmin", db: "bitcoin" } ]
  }
)
```

###Run CheckoutCrypto Dart worker container with mongo

```
docker run --name cc-dart -p 4042:4042 --link mongo:mongo -it -d checkoutcrypto/worker-dart
```

##Required Setup for a single/daemon run

Edit the user and database, ip, port, etc for mongo and whatever you want your dart http server to be.

```
sudo docker exec -it cc-dart /bin/bash 
vi /worker/bin/main.dart
```

```
  ///// HTTP Server Setup
  srvConfig["server_ip"] = "127.0.0.1";
  srvConfig["server_port"] = 4042;
  ///// Mongo Config
  srvConfig["mongo_ip"] = "127.0.0.1";
  srvConfig["mongo_port"] = "27017";
  srvConfig["mongo_table"] = "bitcoin";
  srvConfig["mongo_user"] ="test";
  srvConfig["mongo_pass"] = "testpass";
```
##Required Setup, configuration and post-installation

1. Add CheckoutCrypto Site Database connection 
2. Add Bitcoin RPC settings
3. Generate a key for our client(Front end API)
4. Start Server

- [CheckoutCrypto Drupal Site and Database](https://registry.hub.docker.com/u/checkoutcrypto/site/) Installed and configured separately.
- [Bitcoin daemon](https://bitcoin.org/en/download)

## Menu Usage:

```
 docker run -d -p 4042:4042 --link mongo:mongo checkoutcrypto/worker-dart dart /worker/bin/main.dart
```
## Run Server Standalone

```
 docker run -d -it -p 4042:4042 --link mongo:mongo checkoutcrypto/worker-dart dart /worker/bin/main.dart  -server
```

##CheckoutCrypto Worker Dart Client Example

This is a dart client connection example, to connect to this repository's dart worker.

```
String url = "http://127.0.0.1:4042"
request = new HttpRequest();
request.onReadyStateChange.listen(onData);
request.open('POST', url);
request.send('{"apikey":"$apikey", "coin":"BTC", "action":"getnewaddress", "params":{"uid":1, "account":"fee", "address":"", "recipient":"", "amount":""} }');
```

[Read more](https://github.com/hutchgrant/dart-worker)



Detailed site instructions on CheckoutCrypto's site installation and configuration can be found in that repository's readme https://github.com/CheckoutCrypto/site
