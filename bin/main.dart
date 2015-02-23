// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import '../lib/menu.dart';
import 'Cache.dart';
import '../lib/objects/daeobj.dart';
import '../lib/objects/dbobj.dart';
import '../lib/server.dart';


main() {
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
        /// if not started with any args
        menuCntrl(db, daemons, value);
        /// 5.  start server
        var server = new Server(db, daemons, apikey);
      });
    });
  });


}
