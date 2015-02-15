library parse;

import 'dart:io';
import './objects/daeobj.dart';
import 'dart:convert' show JSON;


class Parse {

String error;

Parse(){
  error = "";
}

/*
 * Parse the RPC Call response
 */
void parseResponse(var result){
  print(result['result']);
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
  var errorDecode = JSON.decode(e.toString());
  var sErrorCode = errorDecode["error"]["code"];
  var sErrorMsg = errorDecode["error"]["message"];
  
  String Msg = "";

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
      }else if(sErrorCode == -3){
         Msg = "WARNING Send Amount to small!!  code: $sErrorCode";
      }else{
         Msg = " the daemon appears to be offline or there are no more work orders";
      }
      return Msg;
}


}