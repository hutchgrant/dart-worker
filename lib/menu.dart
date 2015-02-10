// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'objects/daeObj.dart';
import 'objects/dbObj.dart';
import '../bin/Cache.dart';
import 'server.dart';
import 'cipher.dart';

daeObjs daemons;
dbObj  db;
  

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
      /// generate api key
      Caesar c2=new Caesar(2547832562734583824582353);
      apikey = c2.encrypt("872314234CH2DSAECKD3d9OUT8ada2ECRYVaPTO90-a-ad");
      var cache = new Cache();
      cache.cachePref(apikey);
      print("APIKEY = $apikey"); 
      break;
    case 4:
      /// start server
      var server = new Server(db,dae,apikey);
      break;
  }
}


/*
 * Display Main Menu
 */
  int Menu(){
    String menuIn = "";
    int menuSel = 0;
    /// init cached objects db + daemons + apikey
    stdout.writeln("CheckoutCrypto Menu");
    stdout.writeln("Options");

    stdout.writeln("1) Add remote DB");
    stdout.writeln("2) Add Rpc Coin");
    stdout.writeln("3) Generate Worker key");
    stdout.writeln("4) Start Server");
    menuIn = stdin.readLineSync();
    
    stdout.writeln("you selected $menuIn");
    menuSel = int.parse(menuIn);
    return menuSel;
  }
  
  /*
   * Display Database Option Menu
   */
  void DBMenu(dbObj db){
    String menuIn = "";
    stdout.writeln("CheckoutCrypto Database Menu");
    stdout.writeln("Options");

    stdout.writeln("1) Add remote DB");
    stdout.writeln("2) Edit Remote DB");
    stdout.writeln("3) Display Remote DB");

    menuIn = stdin.readLineSync();
    
    
    switch(int.parse(menuIn)){
      case 1:   ServiceDbAdd();  break;
      case 2:   ServiceDbEdit(db); break;
      case 3:   db.display(); break;
    }
  }
 
  /*
   * Display Form to Add to Mysql DB cache
   */
  void ServiceDbAdd(){
    String server, name, user, pass, confirm;
    bool dbExit = false;
    
    /// Reminder: do while loop until user confirmation information is correct
    stdout.writeln("CheckoutCrypto Database Menu");
    stdout.writeln("Database Entry");

    stdout.writeln("Enter the MySQL Server:");
    server = stdin.readLineSync();
    stdout.writeln("Enter the MySQL Database Name:");
    name = stdin.readLineSync();
    stdout.writeln("Enter the MySQL User:");
    user = stdin.readLineSync();
    stdout.writeln("Enter the MySQL Pass:");
    pass = stdin.readLineSync();
    
    var nwDB = new dbObj();
    nwDB.insert(server, name, user, pass);
    nwDB.display();
    
    stdout.writeln("Is this the correct MySQL information for: $server ? <y/n>");
         confirm = stdin.readLineSync();
         
         if(confirm == "y"){
           var cache = new Cache();
           cache.cacheDB(nwDB);
           dbExit = true; 
         }
  }
  
  /*
   * Display Form to Edit Mysql DB cache
   */
  void ServiceDbEdit(dbObj db){
    String server, name, user, pass, confirm;
    bool dbExit = false;
    String dbEditSel;
    
    /// Reminder: do while loop until user confirmation information is correct
    stdout.writeln("CheckoutCrypto Database Menu");
    stdout.writeln("Database Edit");

    stdout.writeln("Current db cache:");
    db.display();
    stdout.writeln("Which parameter would you like to edit?(0 all the above)");
    dbEditSel = stdin.readLineSync();
    
    server = db.ServerIP;
    name = db.ServerDatabaseName;
    user = db.ServerUser;
    pass = db.ServerPass;
    
    switch(int.parse(dbEditSel)){
      case 1:
        stdout.writeln("Edit the MySQL Server from: $server to:");
        server = stdin.readLineSync();
        break;
      case 2:
        name = db.ServerDatabaseName;
        stdout.writeln("Edit the Database Name from: $name to:");
        name = stdin.readLineSync();
        break;
      case 3:
        user = db.ServerUser;
        stdout.writeln("Edit the Database UserName from: $user to:");
        user = stdin.readLineSync();
        break;
      case 4:
        pass = db.ServerPass;
        stdout.writeln("Edit the Database UserPass from: $pass to:");
        pass = stdin.readLineSync();
        break;
      case 0:
        server = db.ServerIP;
        stdout.writeln("Edit the MySQL Server from: $server to:");
        server = stdin.readLineSync();
        name = db.ServerDatabaseName;
        stdout.writeln("Edit the Database Name from: $name to:");
        name = stdin.readLineSync();
        user = db.ServerUser;
        stdout.writeln("Edit the Database UserName from: $user to:");
        user = stdin.readLineSync();
        pass = db.ServerPass;
        stdout.writeln("Edit the Database UserPass from: $pass to:");
        pass = stdin.readLineSync();
    }
    
    var nwDB = new dbObj();
    nwDB.insert(server, name, user, pass);
    nwDB.display();
    
    stdout.writeln("Is this the correct MySQL information for: $server ? <y/n>");
         confirm = stdin.readLineSync();
         
         if(confirm == "y"){
           var cache = new Cache();
            cache.cacheDB(nwDB);
           dbExit = true; 
         }
  }
  
  /*
   * Display Main RPC Menu Options
   */
  void RpcMenu(daeObjs dae){
    String menuIn = "";
    
    stdout.writeln("CheckoutCrypto RPC Menu");
    stdout.writeln("Options");

    stdout.writeln("1) Add RPC Coin");
    stdout.writeln("2) Edit RPC Coins");
    stdout.writeln("3) Display RPC Coins");
    menuIn = stdin.readLineSync();
    
    switch(int.parse(menuIn)){
      case 1:   RpcCoinAdd();  break;
      case 2:   RpcCoinEdit(); break;
      case 3:   daemons.displayAll(); break;
    }
  }
  
  /*
   * Display Form to add RPC connections
   */
  void RpcCoinAdd(){
      String user, pass, server, walpass, coin, strport, strfee, strtxfee, strMxConf, confirm;
      int port, mxConf;
      double fee, txfee, rate = 0.0;
      bool rpcExit = false;
      
      /// Reminder: do while loop until user confirmation information is correct
      stdout.writeln("CheckoutCrypto RPC Menu");
      stdout.writeln("RPC Entry");

      stdout.writeln("3) Enter the Rpc Coin:");
      coin = stdin.readLineSync();
      stdout.writeln("1) Enter the RPC User:");
      user = stdin.readLineSync();
      stdout.writeln("2) Enter the RPC Pass:");
      pass = stdin.readLineSync();
      stdout.writeln("2) Enter the Wallet Decryption Pass:");
      walpass = stdin.readLineSync();
      stdout.writeln("3) Enter the Rpc Server IP:");
      server = stdin.readLineSync();
      stdout.writeln("3) Enter the Rpc Port:");
      strport = stdin.readLineSync();
      stdout.writeln("3) Enter the Rpc Default Fee(service fee):");
      strfee = stdin.readLineSync();
      stdout.writeln("3) Enter the Rpc Default TxFee(miner's fee):");
      strtxfee = stdin.readLineSync();
      stdout.writeln("3) Enter the Rpc Max Confirmation for service");
      strMxConf = stdin.readLineSync();
      
      port = int.parse(strport);
      mxConf = int.parse(strMxConf);
      fee = double.parse(strfee);
      txfee = double.parse(strtxfee);
      
      var daemon = new daeObj();
      daemon.insert(coin, user, pass, server, port, walpass, fee, txfee, rate, mxConf, true);
      daemon.display();
      
      stdout.writeln("Is this the correct RPC information for: $coin ? <y/n>");
      confirm = stdin.readLineSync();
      
      if(confirm == "y"){
        var cache = new Cache();
         cache.cacheCoin(daemon);
        rpcExit = true; 
      }
  }
  
  /*
   * Display Form to Edit RPC connections
   */ 
  void RpcCoinEdit(){
    
    
  }
