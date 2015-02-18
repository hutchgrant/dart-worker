// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


/// Worker HTTP Server library
library Server;

import 'dart:io';
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
  String error;
  bool err;
  dbConnect dbConn;
  
  Server(dbObj sql, daeObjs dae, String key){
    apikey = key;
    db = sql;
    daemons = dae;
    dbConn = new dbConnect(sql);
    parse = new Parse();
    print("Starting HTTP Server on $IP at Port: $port");

    HttpServer.bind(IP, port)
           .then(listenForRequests)
           .catchError((e) => print('error: ${e.toString()}'));
  }

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
      },
      onDone: () => print('No more requests.'),
      onError: (e ) => print(e.toString()));
    }
    
    void handlePost(HttpRequest req) {
      StringBuffer data = new StringBuffer();
      addCorsHeaders(req.response);
      
      req.listen((buffer) {
        data.write(new String.fromCharCodes(buffer));
      }, onDone: () {
        var decoded = JSON.decode(data.toString());
        if (decoded.containsKey('apikey')  && decoded.containsKey('coin') && decoded.containsKey('action') && decoded.containsKey('params')) {
          if(decoded["apikey"] == apikey){
            if(parse.checkCoinActionParams(daemons, decoded["coin"], decoded["action"], decoded["params"])){
                rpcHandler(req, decoded);
            }
          }
        }
      }, onError: (_) {
        print('Request listen error.');
      });
    }
    
    void rpcHandler(HttpRequest req, var decoded){
      var rpc = new rpcCntrl(daemons);
      var params = new Map();

      params["coin"] = decoded["coin"];
      params["action"] = decoded["action"];
      params["uid"] = decoded["params"]["uid"];
      if(decoded["params"].containsKey("address")){ params["address"] = decoded["params"]["address"]; }
      if(decoded["params"].containsKey("account")){ params["account"] = decoded["params"]["account"]; }
      if(decoded["params"].containsKey("recipient")){ params["recipient"] = decoded["params"]["recipient"]; }
      if(decoded["params"].containsKey("amount")){ params["amount"] = decoded["params"]["amount"]; }
      if(decoded["params"].containsKey("confirms")){ params["confirms"] = decoded["params"]["confirms"]; }

      rpc.call(decoded["coin"], decoded["action"], params).then((result) => parse.parseResponse(params, result, dbConn))
      
      .catchError((e){
          error = parse.parseError(e.toString());
          print(error);
      }).then((result2){
          if(error.isNotEmpty){
            req.response.writeln('[{"status":"error", "result":"${error}"}]');
          }else{
            req.response.writeln('[{"status":"success", "result":"${result2}"}]');
          }
         req.response.close();
      });
    }
    
    void defaultHandler(HttpRequest req) {
      HttpResponse res = req.response;
      addCorsHeaders(res);
      res.statusCode = HttpStatus.NOT_FOUND;
      res.write('Not found: ${req.method}, ${req.uri.path}');
      res.close();
    }
    
    void handleOptions(HttpRequest req) {
      HttpResponse res = req.response;
      addCorsHeaders(res);
      print('${req.method}: ${req.uri.path}');
      res.statusCode = HttpStatus.NO_CONTENT;
      res.close();
    }
    
    void addCorsHeaders(HttpResponse res) {
      res.headers.add('Access-Control-Allow-Origin', '*');
      res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
      res.headers.add('Access-Control-Allow-Headers',
          'Origin, X-Requested-With, Content-Type, Accept');
    }

}
