// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The MySQL DB Object library
library dbObj;

class dbObj{
  
  String dUser, dPass, dName, dHost;
  
  dbObj(){
    dUser = "";
    dPass = "";
    dName = "";
    dHost = "";
  }
      
  void insert(String server, String name, String user, String pass ){
    this.ServerIP = server;
    this.ServerDatabaseName = name;
    this.ServerUser = user;
    this.ServerPass = pass;
  }
  
  String get ServerIP => this.dHost;
  String get ServerDatabaseName =>this.dName;
  String get ServerUser => this.dUser;
  String get ServerPass => this.dPass;
  
  void set ServerIP(String serv){
    this.dHost = serv;
  }
  void set ServerDatabaseName(String name){
    this.dName = name;
  }
  void set ServerUser(String user){
    this.dUser = user;
  }
  void set ServerPass(String pass){
    this.dPass = pass;
  }
  
  void display(){
    print("User:$dUser");
    print("Pass:$dPass");
    print("Database:$dName");
    print("Server:$dHost");
  }
  
}