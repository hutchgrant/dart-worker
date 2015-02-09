// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


/// Worker MongoDB Cache library
library Cache;

import 'package:mongo_dart/mongo_dart.dart';
import '../lib/objects/daeObj.dart';
import '../lib/objects/dbObj.dart';
import 'dart:async';

class Cache {
  
  Db db;
  String dbServer = "127.0.0.1";
  String dbPort = "27017";
  String dbName = "testdb";
  String usrName = "default";
  String usrPass = "root";  double rate = 0.0;
  
  Cache(){
  }
  
  void init(){
    db = new Db("mongodb://$usrName:$usrPass@$dbServer:$dbPort/$dbName");
  }
  
  /*
   * SELECT all daemon RPC info
   */
  daeObjs getCoins(){
    this.init();
    var daemons = new daeObjs(); 
    var table = db.collection('coins');
       db.open().then((_){
           print(" Retrieving all RPC Coin info");
           return table.find()
               .forEach((col) => daemons.insert("test","test","test","test",0,"test",rate,rate,rate,2,true));     
         }).then((_) {
           print('closing db');
           db.close();
           return daemons;
         });
  }
  /*
   * SELECT all mysql remote db info
   */
  dbObj getDB(){
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
           mysqlDB.display();
           return mysqlDB;
         });
  }
  /*
   * SELECT all API preferences e.g. apikey
   */
  String getPref(){
    this.init();
    String apikey = "";
    var table = db.collection('pref');
       db.open().then((_){
           print(" Retrieving all API Preferences");
           return table.find();   //// Reminder to add table + col + select
         }).then((_) {
           print('closing db');
           db.close();
           return apikey;
         });
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
    var table = db.collection('mysql');
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
    
  }
}