# dart_worker

A dart port for CheckoutCrypto's multi-cryptocurrency worker.

Install:
==========
```
sudo add-apt-repository ppa:hachre/dart
sudo apt-get update
sudo apt-get install darteditor dartsdk dartium pub git mongodb robomongo

git clone https://github.com/hutchgrant/dart-worker
cd ./dart-worker
pub get
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

<ol>
<li>Before you begin, you need to create a mongo database and user, edit top of ./bin/Cache.dart</li>
<li>Add a remote DB to send the results of api queries</li>
<li>Add each cryptocurrency RPC config information 
<ul> 
<li>Coin(short form)</li>
<li>RPC User</li>
<li>RPC Password</li>
<li>RPC Server</li>
<li>RPC Port</li>
<li>fee(host's service) + txfee</li>
<li>Rate(set by cron later)</li>
<li>Max Confirmation - The confirm at which a trade, deposit, withdrawal, is made</li>
<li>Enable/Disable(true/false) </li>
</ul></li>
<li>Generate an API key</li>
<li>Start the HTTP Server - Set IP and port in ./lib/server.dart</li>
</ol>



Calls are made from a front end api, utilizing a POST request to a REST api, accompanied by the worker's generated key(see above).  

Connect to the Server using a client POST function similar to this:
```
String url = "http://127.0.0.1:4042"
request = new HttpRequest();
request.onReadyStateChange.listen(onData);
request.open('POST', url);
request.send('{"apikey":"$apikey", "coin":"BTC", "action":"getbalance", "params":["fee"] }');
```
