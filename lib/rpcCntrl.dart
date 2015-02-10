// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


import './objects/daeObj.dart';
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
  
  rpcCntrl(daeObjs dae,  [rpcCntrlLog this.log]){
    daemons = dae;
  }
  
  void connect(String coincode){
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
  
 Future call(String coincode, String method, { params: const []}) {
   connect(coincode);
     final payload = JSON.encode({
       'jsonrpc': '1.0',
       'method': method,
       'params': params,
       'id': new DateTime.now().millisecondsSinceEpoch
     });
     if(debug) { this.log(coincode+' daemon request: ' + payload); }

     final completer = new Completer();

     _http_client
     .postUrl(uri)
     .then((HttpClientRequest request) {
       request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
       request.contentLength = payload.length;
       request.write(payload);
       
       return request.close();
     })
     .then((HttpClientResponse response)
       => response.fold('', (String prev, List el) => prev += new String.fromCharCodes(el)))
     .then((String string_data) {
       if(debug) { this.log(coincode+' daemon response: $string_data'); }

       final _data = JSON.decode(string_data);
       
       if(_data['result'] != null) {
         completer.complete(_data);
       } else if (_data['error'] != null) {
         completer.completeError(_data['error']);
       }
     }).catchError((e) {
       if(debug) { this.log(coincode+' daemon error: ' + e.toString()); }
       completer.completeError(e);
     });

     return completer.future;
   } 
 }