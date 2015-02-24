// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


/// Worker MongoDB Cache library
library cache;

import 'package:mongo_dart/mongo_dart.dart';
import '../lib/objects/daeobj.dart';
import '../lib/objects/dbobj.dart';
import 'dart:async';

class Cache {
  /* INSERT YOUR MONGODB ACCOUNT AND DB */
  String dbServer = "127.0.0.1";
  String dbPort = "27017";
  String dbName = "testdb";
  String usrName = "";
  String usrPass = "";  
  
  Db db;
  Cache(){
  }
  
  void init(){
    db = new Db("mongodb://$usrName:$usrPass@$dbServer:$dbPort/$dbName");
  }
  
  /*
   * SELECT all daemon RPC info
   */
  Future<daeObjs> getCoins(){
    var completer = new Completer();

    this.init();
    var daemons = new daeObjs(); 
    var table = db.collection('coins');
       db.open().then((_){
           print(" Retrieving all RPC Coin info");
           return table.find()
               .forEach((col) => daemons.insert(col["rpcCoin"], col["rpcUser"], col["rpcPass"], col["rpcServer"], col["rpcPort"], col["rpcWallPass"],
                   col["rpcFee"], col["rpcTxFee"], col["rpcRate"], col["rpcMaxConf"], col["rpcEnable"] ));
         }).then((_) {
           print('closing db');
           db.close();
           completer.complete(daemons);
         });
       return completer.future;
  }
  /*
   * SELECT all mysql remote db info
   */
  Future<dbObj> getDB(){
    var completer = new Completer();
    this.init();
    var mysqlDB = new dbObj();
    var table = db.collection('mysql');
       db.open().then((_){
           print(" Retrieving all MySQL Server info");
           return table.find()
               .forEach((col) => mysqlDB.insert(col["ip"], col["name"], col["user"], col["pass"]) );     
         }).then((_) {
           print('closing db');
           db.close();
           String ip = mysqlDB.ServerIP;
           completer.complete(mysqlDB);
         });
       return completer.future;
  }
  /*
   * SELECT all API preferences e.g. apikey
   */
  Future<String> getPref(){
    var completer = new Completer();

    this.init();
    String apikey = "";
    var table = db.collection('pref');
       db.open().then((_){
           print(" Retrieving all API Preferences");
           return table.find()
               .forEach((col){ apikey = col["apikey"]; });        //// Reminder to add table + col + select
         }).then((_) {
           print('closing db');
           db.close();
           completer.complete("$apikey");
         });
       return completer.future;

  }
  /*
   * INSERT remote mysql db info
   */
  void cacheDB(dbObj sql){
    this.init();
    var table = db.collection('mysql');
    db.open().then((_){
      print(" INSERT mysql data into cache");
      var data = [];
      data.add({'ip': sql.ServerIP, 'name': sql.ServerDatabaseName, 'user': sql.ServerUser, 'pass': sql.ServerPass});
         
      return Future.forEach(data, (elem){
        return table.insert(elem, writeConcern: WriteConcern.ACKNOWLEDGED);
      });    
    });
  }
  /*
   * INSERT daemon RPC info
   */
  void cacheCoin(daeObj dae){
    this.init();
    var table = db.collection('coins');
    db.open().then((_){
      print(" INSERT RPC data into cache");
      var data = [];
      data.add({'rpcUser': dae.rpcUser, 'rpcPass': dae.rpcPass, 
        'rpcServer': dae.rpcServer, 'rpcPort': dae.rpcPort,
        'rpcWallPass': dae.rpcWallPass, 'rpcCoin': dae.rpcCoin,
        'rpcFee': dae.rpcFee, 'rpcTxFee': dae.rpcTxFee,
        'rpcEnable': dae.rpcEnable, 'rpcMaxConf': dae.rpcMaxConf,
        'rpcRate': dae.rpcRate});
         
      return Future.forEach(data, (elem){
        return table.insert(elem, writeConcern: WriteConcern.ACKNOWLEDGED);
      });    
    });
  }
  /*
   * INSERT api preferences e.g. apikey
   */
  void cachePref(String apikey){
    this.init();
    var table = db.collection('pref');
    db.open().then((_){
      print(" INSERT apikey data into cache");
      var data = [];
      data.add({'apikey': apikey});
         
      return Future.forEach(data, (elem){
        return table.insert(elem, writeConcern: WriteConcern.ACKNOWLEDGED);
      });    
    });
  }
}