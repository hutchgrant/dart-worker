// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import '../lib/menu.dart';
import 'Cache.dart';
import '../lib/objects/daeobj.dart';
import '../lib/objects/dbobj.dart';
import '../lib/server.dart';


main(List<String> arguments) {

  bool menu = true;
  if(arguments.length != 0){
     if(arguments[0] == "-server"){
      menu = false;
    } 
  }
  
  var cache = new Cache();
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
          menuCntrl(db, daemons, value);
        }else{
          var server = new Server(db, daemons, apikey);
        }
      });
    });
  });


}
