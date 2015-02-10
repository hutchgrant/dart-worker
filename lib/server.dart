// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


/// Worker HTTP Server library
library Server;

import 'dart:io';
import 'dart:convert' show JSON;
import './objects/daeobj.dart';
import './objects/dbobj.dart';
import 'rpccntrl.dart';

class Server {
  
  int port = 4042;
  String IP = "127.0.0.1";
  var db, daemons;
  String apikey;
  
  Server(dbObj sql, daeObjs dae, String key){
    apikey = key;
    db = sql;
    daemons = dae;
    
    print("Starting HTTP Server on $IP at Port: $port");

    HttpServer.bind(IP, port)
           .then(listenForRequests)
           .catchError((e) => print('error: ${e.toString()}'));
  }

    listenForRequests(_server) {
      _server.listen((HttpRequest request) {
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
    
        if (decoded.containsKey('apikey')) {
          if(decoded["apikey"] == apikey){
            var rpc = new rpcCntrl(daemons);
            rpc.call("BTC", "getbalance", params:['fee',0]).then((result) => print(result));
          }
          req.response.writeln('Working');
          req.response.close();
        } 
      }, onError: (_) {
        print('Request listen error.');
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
