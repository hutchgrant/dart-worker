// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import '../lib/menu.dart';
import '../lib/server.dart';
import 'Cache.dart';
import '../lib/objects/daeObj.dart';
import '../lib/objects/dbObj.dart';

main() {

  /// if not started with any args
  
  var daemons = new daeObjs();
  var db = new dbObj();
  var cache = new Cache();
  String apikey = "";
  
  /// 1. Asynchronous thread
//  daemons = cache.getCoins();
 // daemons.displayAll();
  /// 2. Asynchronous thread
 // db  = cache.getDB();
 // db.display();
  /// 3. Asynchronous thread
  //apikey = cache.getPref();  
 // print("APIKEY : $apikey");
  /// 4. Asynchronous thread
    menuCntrl(db, daemons, apikey);
  /// 5.  start server
 // var server = new Server(db, daemons, apikey);
  
}

void menuCntrl(dbObj db, daeObjs dae, String apikey){
  int menuSel = 0;
  menuSel = Menu();
 
  switch(menuSel){
    case 1:
      DBMenu(db);
      break;
    case 2:
      RpcMenu(dae);
      break;
    case 3:
      print("APIKEY = $apikey");
      /// generate api key
      break;
    case 4:
      /// start server
      var server = new Server();
      break;
  }
  
}
