// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


/// Worker HTTP Server library
library Server;

import 'dart:io';
import 'dart:async';
import 'dart:convert' show JSON;
import './objects/daeobj.dart';
import './objects/dbobj.dart';
import 'rpccntrl.dart';
import 'parse.dart';
import 'dbconnect.dart';

class Server {

  int port = 4042;
  String IP = "127.0.0.1";
  var db, daemons;
  String apikey;
  Parse parse;
  String error = "";
  var errorcode = "";

  bool err;
  dbConnect dbConn;

  /*
   *  Server Constructor
   */
  Server(dbObj sql, daeObjs dae, String key) {
    apikey = key;
    db = sql;
    daemons = dae;
    dbConn = new dbConnect(sql);
    parse = new Parse();
    setAllTxFees(dae).then((_){
      print("Starting HTTP Server on $IP at Port: $port");
      HttpServer.bind(IP, port).then(listenForRequests).catchError((e) => print('error: ${e.toString()}'));
    });

  }

  /*
   *  Handle the server listener control options.
   */
  listenForRequests(_server) {
    _server.listen((HttpRequest request) {

      error = "";
      err = false;

      switch (request.method) {
        case 'POST':
          handlePost(request);
          break;
        case 'OPTION':
          handleOptions(request);
          break;
        default:
          defaultHandler(request);
          break;
      }
    }, onDone: () => print('No more requests.'), onError: (e) => print(e.toString()));
  }


  /*
   *  Handle initial socket connection, validation input, decode json
   */
  void handlePost(HttpRequest req) {
    StringBuffer data = new StringBuffer();
    addCorsHeaders(req.response);

    req.listen((buffer) {
      data.write(new String.fromCharCodes(buffer));
    }, onDone: () {
      var decoded = JSON.decode(data.toString());
      if (decoded.containsKey('apikey') && decoded.containsKey('coin') && decoded.containsKey('action') && decoded.containsKey('params')) {
        if (decoded["apikey"] == apikey) {
          if (parse.checkCoinActionParams(daemons, decoded["coin"], decoded["action"], decoded["params"])) {
            rpcHandler(req, decoded, daemons);
          }
        }
      }
    }, onError: (_) {
      print('Request listen error.');
    });
  }
  
  /*
   *  Prepare and create the initial RPC request, when socket connection received
   */
  void rpcHandler(HttpRequest req, var decoded, daeObjs daemons) {
    var rpc = new rpcCntrl(daemons);
    var params = new Map();

    params["coin"] = decoded["coin"];
    params["action"] = decoded["action"];
    params["uid"] = decoded["params"]["uid"];
    if (decoded["params"].containsKey("address")) {
      params["address"] = decoded["params"]["address"];
    }
    if (decoded["params"].containsKey("account")) {
      params["account"] = decoded["params"]["account"];
    }
    if (decoded["params"].containsKey("recipient")) {
      params["recipient"] = decoded["params"]["recipient"];
    }
    if (decoded["params"].containsKey("amount")) {
      params["amount"] = decoded["params"]["amount"];
    }
    if (decoded["params"].containsKey("confirms")) {
      params["confirms"] = decoded["params"]["confirms"];
    }

    rpc.call(decoded["coin"], decoded["action"], params).then((result) => parse.parseResponse(params, result, dbConn)).catchError((e) {
      parseError(e);
    }).then((result) {
      respond(req, rpc, decoded, daemons, params, result);
    });
  }
  
  /*
   *  Handle all the RPC default Coin fees, 
   * for now only calling on initialization of server
   */
  Future setAllTxFees(daeObjs dae){
    final completer = new Completer();
    var params = new Map();
    var rpc = new rpcCntrl(dae);
    for(int x=0; x<dae.size; x++){
      params["amount"] = dae.grabByIdx(x).dTxFee;
      
      rpc.call(dae.grabByIdx(x).dCoin, "settxfee", params).then((result) => parse.parseResponse(params, result, dbConn)).catchError((e) {
        parseError(e);
      })
      .then((result) {
        print(dae.grabByIdx(x).dCoin + " txfee set and coin enabled");
        if(x == dae.size-1){
          completer.complete();
        }
      });

    }
    return completer.future;
  }

  /*
   *  Parse our global error and error codes
   */
  void parseError(var err) {
    error = parse.parseError(err.toString());
    errorcode = JSON.decode(err.toString());
  }

  /*
   *  Respond to the result of RPC, do we need to unlock? 
   * do we want to run another rpc command, etc
   */
  void respond(HttpRequest req, rpcCntrl rpc, var decoded, daeObjs daemons, var params, var result) {
    if (error.isNotEmpty) {
      if (errorcode["error"]["code"] == -13) {    /// Unlock wallet on unlock error
        errorcode = "";
        error = "";
        print("WALLET UNLOCKING-----------------------");
        params["action"] = "walletpassphrase";
        params["passphrase"] = daemons.grabByCoin(decoded["coin"]).rpcWallPass;
        rpc.call(decoded["coin"], params["action"], params).then((result2) => parse.parseResponse(params, result2, dbConn)).catchError((errUnlock) {
          parseError(errUnlock);
        }).then((result3) {
          if (error.isNotEmpty) {
            sendError(req);
          } else {
            errorcode = "";
            error = "";
            rpc.call(decoded["coin"], decoded["action"], params).then((result4) => parse.parseResponse(params, result4, dbConn)).catchError((err) {
              parseError(err);
            }).then((result5) {
              if (error.isNotEmpty) {
                sendError(req);
              } else {
                sendResponse(req, result5);
              }
            });
          }
        });
      } else {
        sendError(req);
      }
    } else {
      sendResponse(req, result);
    }
  }

  /*
   * Return Error specific response through HTTP request
   */
  void sendError(HttpRequest req) {
    req.response.writeln('[{"status":"error", "result":"${error}"}]');
    req.response.close();

  }
  
  /*
   * Return Specific response through HTTP request
   */
  void sendResponse(HttpRequest req, var msg) {
    req.response.writeln('[{"status":"success", "result":"${msg}"}]');
    req.response.close();
  }

  /*
   * Default 404 handler
   */
  void defaultHandler(HttpRequest req) {
    HttpResponse res = req.response;
    addCorsHeaders(res);
    res.statusCode = HttpStatus.NOT_FOUND;
    res.write('Not found: ${req.method}, ${req.uri.path}');
    res.close();
  }


  /*
   *  Handle broken paths
   */
  void handleOptions(HttpRequest req) {
    HttpResponse res = req.response;
    addCorsHeaders(res);
    print('${req.method}: ${req.uri.path}');
    res.statusCode = HttpStatus.NO_CONTENT;
    res.close();
  }

  /*
   *  Set respond headers
   */
  void addCorsHeaders(HttpResponse res) {
    res.headers.add('Access-Control-Allow-Origin', '*');
    res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  }

}
