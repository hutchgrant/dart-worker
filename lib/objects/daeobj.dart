// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The daemon Object library
library daeObjs;

class daeObjs {
  
  List<daeObj> daemons;
  int size;
  
  daeObjs(){
    daemons = new List<daeObj>();
    size = 0;
  }
  
  void insert(String coin, String user, String pass, String serv, int port, 
           String walPass, double fee, double txfee, double rate, 
           int mxConf, bool enable){
    
    var nwDaeObj = new daeObj();
    nwDaeObj.insert(coin, user, pass, serv, port, walPass, fee, txfee,
                    rate, mxConf, enable);
    this.daemons.add(nwDaeObj);
    this.size++;
  }
  bool verifyCoinExists(String coincode){
    for(int x= 0; x < size; x++){
      if(daemons.elementAt(x).dCoin == coincode){
        return true;
      }
    }
  }
  daeObj grabByCoin(String coincode){
    for(int x= 0; x < size; x++){
      if(daemons.elementAt(x).dCoin == coincode){
        return daemons.elementAt(x);
      }
    }
  }
  daeObj grabByIdx(int index){
    return daemons.elementAt(index);
  }
  void displayAll(){
    for(int x=0; x<size; x++){
      daemons.elementAt(x).display();
    }
  }
  
}

class daeObj {
  String dUser, dPass, dServer, dCoin, dWalPas;
  int dPort, dMxConf;
  double dRate, dFee, dTxFee;
  bool dEnabled;
  
  daeObj(){
    dUser = "";
    dPass = "";
    dServer = "";
    dCoin = "";
    dWalPas = "";
    dRate = 0.0;
    dFee = 0.0;
    dTxFee = 0.0;
    dEnabled = true;
  }
  
  void insert(String coin, String user, String pass, String serv, int port, 
        String walPass, double fee, double txfee, double rate, 
        int mxConf, bool enable){
      this.rpcCoin = coin;
      this.rpcUser = user;
      this.rpcPass = pass;
      this.rpcServer = serv;
      this.rpcPort = port;
      this.rpcFee = fee;
      this.rpcTxFee = txfee;
      this.rpcMaxConf = mxConf;
      this.rpcEnable = enable;
  }
  void display(){
    print("Coin:$dCoin User:$dUser Pass:$dPass ");
    print("Server:$dServer Port:$dPort ");
    print("WalletPass:$dWalPas ");
    print("Fee:$dFee Txfee:$dTxFee Rate:$dRate");
    print("MaxConfirm:$dMxConf");
    print("Enabled:$dEnabled");
  }
  
  void set rpcCoin(String coin) {
    this.dCoin = coin;
  }
  void set rpcUser(String user) {
    this.dUser = user;
  }
  void set rpcPass(String pass) {
    this.dPass = pass;
  }
  void set rpcServer(String serv) {
    this.dServer = serv;
  }
  void set rpcPort(int port) {
    this.dPort = port;
  }
  void set rpcWallPass(String pass) {
    this.dWalPas = pass;
  }
  void set rpcFee(double fee) {
    this.dFee = fee;
  }
  void set rpcTxFee(double txfee) {
    this.dTxFee = txfee;
  }
  void set rpcRate(double rate) {
    this.dRate = rate;
  }
  void set rpcMaxConf(int mxConf) {
    this.dMxConf = mxConf;
  }
  void set rpcEnable(bool enabled) {
    this.dEnabled = enabled;
  }
  
  String get rpcCoin => dCoin;
  String get rpcUser => dUser;
  String get rpcPass => dPass;
  String get rpcServer => dServer;
  int get rpcPort => dPort;
  String get rpcWallPass => dWalPas;
  double get rpcFee => dFee;
  double get rpcTxFee => dTxFee;
  double get rpcRate => dRate;
  int get rpcMaxConf => dMxConf;
  bool get rpcEnable => dEnabled;
}

