// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library ccserver;

import 'dart:async';
import 'menu.dart';
import 'cache.dart';
import 'objects/daeobj.dart';
import 'objects/dbobj.dart';
import 'server.dart';


class ccServer {

  ccServer(bool menu, var srvConfig) {
    
    var cache = new Cache(srvConfig);
    var daemons = new daeObjs();
    var db = new dbObj();
    String apikey = "";
  
    Future<daeObjs> daeFut() => new Future.value(cache.getCoins());
    Future<dbObj> dbFut() => new Future.value(cache.getDB());
    Future<String> prefFut() => new Future.value(cache.getPref());
  
    daeFut().then((daemons){
      dbFut().then((db){
        prefFut().then((value){
          apikey = value;
          if(menu == true){
            menuCntrl(db, daemons, value, srvConfig);
          }else{
            var server = new Server(db, daemons, apikey, srvConfig);
          }
        });
      });
    });  
  }
}
