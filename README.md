# dart_worker

A dart port for CheckoutCrypto's multi-cryptocurrency worker.

<h3>Install:</h3>
```
sudo add-apt-repository ppa:hachre/dart
sudo apt-get update
sudo apt-get install darteditor dartsdk dartium pub git mongodb robomongo

git clone https://github.com/hutchgrant/dart-worker
cd ./dart-worker
pub get
```
<h3>Local cache</h3>
==============
<p>MongoDB config options are in the file ./dart-worker/bin/Cache.dart
You will need to create a new database and user.</p>

<h3>Remote(or local) site and Database</h3>
==============
```
sudo apt-get install git drush phpmyadmint curl php5-curl apache2 mysql-server mysql-client


Follow instructions at drupal menu, install.
cd /var/www/site/sites/all/ && git clone https://github.com/CheckoutCrypto/site.git
git submodule init && git submodule update
Login as admin, enable all modules, fix configurations e.g. smtp, site config, theme settings, blocks, etc.
```
<p>Detailed site instructions on CheckoutCrypto's site installation and configuration can be found in that repository's readme https://github.com/CheckoutCrypto/site </p>


<h3>Configure:</h3>
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
<li>Add a remote(CheckoutCrypto drupal site) DB to send the results of api queries</li>
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


<h3>Client</h3>

<p>Calls should be made from an authenticated front end api, utilizing a POST request to the dart-worker, accompanied by the worker's generated API key(see above).</p>  

<p>Connect to the Server using a client POST function similar to this:</p>
```
String url = "http://127.0.0.1:4042"
request = new HttpRequest();
request.onReadyStateChange.listen(onData);
request.open('POST', url);
request.send('{"apikey":"$apikey", "coin":"BTC", "action":"getnewaddress", "params":{"uid":1, "account":"fee", "address":"", "recipient":"", "amount":""} }');
```
