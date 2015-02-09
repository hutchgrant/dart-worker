// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


/// Worker HTTP Server library
library Server;

import 'dart:io';
import 'dart:convert' show JSON;

class Server {
  
  Server(){
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4042)
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
