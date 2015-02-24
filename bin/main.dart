// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


import 'package:dart_worker/ccserver.dart';

main(List<String> arguments){
  
  bool menu = true;
  if(arguments.length != 0){
     if(arguments[0] == "-server"){
      menu = false;
    } 
  }
  
  var srvConfig = new Map();
  ///// HTTP Server Setup
  srvConfig["server_ip"] = "127.0.0.1";
  srvConfig["server_port"] = 4042;
  ///// Mongo Config
  srvConfig["mongo_ip"] = "127.0.0.1";
  srvConfig["mongo_port"] = "27017";
  srvConfig["mongo_table"] = "";
  srvConfig["mongo_user"] ="";
  srvConfig["mongo_pass"] = "";
  var server = new ccServer(menu, srvConfig);
}