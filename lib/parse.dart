// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library parse;

import 'dart:async';
import './objects/daeobj.dart';
import './objects/wallet.dart';
import 'dart:convert' show JSON;
import 'dbconnect.dart';
import 'rpccntrl.dart';

class Parse {

String error;
rpcCntrl rpc;

Parse(){
  error = "";
}

/*
 * Parse the RPC Call response
 */
String parseResponse(var params, var result, dbConnect db){

  String baseResult = "";
  double dblResult = 0.0;
  
  switch( params["action"]){
    case "getbalance":
      wallet wall = new wallet();
      baseResult = result['result'].toString();
      dblResult = double.parse(baseResult);
      wall.insert(params["uid"], params["coin"], "", "", dblResult, 0.0, 1, "");
      
      Future balanceUpdate() => new Future.value(db.updateConfirmedBalance(wall));
      balanceUpdate().then((_){
        print("balance updated");
      });
    break;
    case "getnewaddress":
      wallet wall = new wallet();
      baseResult = result['result'].toString();
      
      wall.insert(params["uid"], params["coin"], "", baseResult, 0.0, 0.0, 1, "");
      
      Future addNewAddress() => new Future.value(db.addDefaultWallet(wall));
      addNewAddress().then((_){
        print("new address added");
      });
    break;
    case "getreceivedbyaddress":
      wallet wall = new wallet();
      baseResult = result['result'].toString();
      dblResult = double.parse(baseResult);
      wall.insert(params["uid"], params["coin"], "", params["address"], dblResult, 0.0, params["confirms"], "");
      
      Future addNewAddress() => new Future.value(db.addDefaultWallet(wall));
      addNewAddress().then((_){
        print("amount received by address updated");
      });
    break;
    case "walletpassphrase":
      result['result'] = "unlocked";
    break;
    case "move":
    break;
    case "walletlock":
      result['result'] = "locked";
    break;
    case "settxfee":
      result['result'] = "fee set";
    break;
  }

  print(result['result']);
  return result['result'].toString();
}

/*
 *  RPC Call Validation Control
 */
bool checkCoinActionParams(daeObjs daemons, var coin, var action, var params){
  
  if(checkCoin(daemons, coin)){
    if(checkAction(action)){
      ///checkParams(params)){
        return true;
     /// }
    }
  }
    return false;  
}

/*
 * Check Coins, ensure they are already present and enabled in database cache
 */
bool checkCoin(daeObjs daemons, var coin){
    if(daemons.verifyCoinExists(coin)){
      return true;
    }
    error = "incorrect action";
    return false;
}

/*
 * Check actions, left room to add variables and functions for each action if necessary
 */
bool checkAction(var method){
  if(method == "getnewaddress"){
  }else if(method == "getreceivedbyaddress"){
  }else if(method == "sendfrom"){
  }else if(method == "getbalance"){
  }else if(method == "getaccount"){
  }else if(method == "getaccountaddress"){
  }else if(method == "settxfee"){  
  }else if(method == "gettransaction"){
  }else if(method == "service_charge"){
  }else if(method == "move"){
  }else if(method == "getaccount"){
  }else if(method == "walletpassphrase"){
  }else{
    error = "incorrect action";
    return false;
  }
  return true;
}

/*
 * Check Parameters for each action
 */
void checkParams(var params){
  
}

String parseError(String e){
  
  String Msg = "";
  if(e.startsWith("{")){
  var errorDecode = JSON.decode(e.toString());
  var sErrorCode = errorDecode["error"]["code"];
  var sErrorMsg = errorDecode["error"]["message"];


      if(sErrorCode == -12){     ///for refill key
          Msg =" REFILLING KEYS --------------------------" ;
      }else if(sErrorCode == -15){
         Msg =" unlocking wallet --------------------------" ;
      }else if(sErrorCode == -13){
         Msg =" Wallet needs unlock  code: $sErrorCode";
      }else if(sErrorCode == -17){
         Msg ="wallet already unlocked code :  code: $sErrorCode";
      }else if(sErrorCode == -1){
         Msg = "Missing Parameter for Action !  code: $sErrorCode";
      }else if(sErrorCode == 0){
         Msg = "error code : $sErrorCode";
      }else if(sErrorCode == -6){
         Msg = "WARNING empty wallet  code: $sErrorCode";
      }else if(sErrorCode == -4){
         Msg = "WARNING Send Amount to small!!  code: $sErrorCode";
      }else{
         Msg = " the daemon appears to be offline or there are no more work orders";
      }
  }else{
    Msg = e;
  }
  return Msg;
}


}