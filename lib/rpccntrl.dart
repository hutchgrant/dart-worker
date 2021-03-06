// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


import 'objects/daeobj.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

typedef void rpcCntrlLog(String message);


class rpcCntrl {

  var url;
  daeObjs daemons;

  Uri uri;
  rpcCntrlLog log;
  bool debug = true;
  HttpClient _http_client = new HttpClient();

  rpcCntrl(daeObjs dae, [rpcCntrlLog this.log]) {
    daemons = dae;
  }

  void connect(String coincode) {
    String server, user, pass;
    int port;
    server = daemons.grabByCoin(coincode).rpcServer;
    port = daemons.grabByCoin(coincode).rpcPort;
    user = daemons.grabByCoin(coincode).rpcUser;
    pass = daemons.grabByCoin(coincode).rpcPass;
    url = 'http://$user:$pass@$server:$port';
    this.uri = Uri.parse(url);
    debug = this.log != null;
  }

  List getRPCParams(String method, var params) {
    List rpclist;

    switch (method) {
      case "getnewaddress":
        rpclist = [params["account"]];
        break;
      case "getbalance":
        rpclist = [params["account"]];
        break;
      case "getreceivedbyaddress":
        rpclist = [params["address"], params["confirms"]];
        break;
      case "sendfrom":
        rpclist = [params["account"], params["recipient"], params["amount"]];
        break;
      case "move":
        rpclist = [params["account"], params["recipient"], params["amount"]];
        break;
      case "settxfee":
        rpclist = [params["amount"]];
        break;
      case "walletpassphrase":
        params["timeout"] = 100;
        rpclist = [params["passphrase"], params["timeout"]];
        break;
    }
    return rpclist;
  }

  Future call(String coincode, String method, var paramList) {
    bool error = false;
    List params = getRPCParams(method, paramList);
    connect(coincode);
    final payload = JSON.encode({
      'jsonrpc': '1.0',
      'method': method,
      'params': params,
      'id': new DateTime.now().millisecondsSinceEpoch
    });
    print(payload);
    if (debug) {
      this.log(coincode + ' daemon request: ' + payload);
    }

    final completer = new Completer();

    _http_client.postUrl(uri).then((HttpClientRequest request) {
      request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
      request.contentLength = payload.length;
      request.write(payload);

      return request.close();
    }).then((HttpClientResponse response) => response.fold('', (String prev, List el) => prev += new String.fromCharCodes(el))).then((String string_data) {
      if (debug) {
        this.log(coincode + ' daemon response: $string_data');
      }
      if (!error) {
        final _data = JSON.decode(string_data);
        print(_data);
        if (_data['result'] != null) {
          completer.complete(_data);
        } else if (_data['error'] != null) {
          completer.completeError(string_data);
        } else if (_data['error'] == null) {
          completer.complete(_data);
        }
      }
    }).catchError((e) {
      if (debug) {
        this.log(coincode + ' daemon error: ' + e.toString());
      }
      if (!error) {
        completer.completeError("Daemon RPC Connection Error, check your daemons is running.");
      }
    });

    return completer.future;
  }
}
