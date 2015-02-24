// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library wallet;

class wallet {

  String wAddress, wAccount, wCoin, wFlag;
  double wAmount, wFee;
  int wUID, wConfirm;

  wallet() {
    wAddress = "";
    wAccount = "";
    wCoin = "";
    wAmount = 0.0;
    wUID = 0;
    wConfirm = 0;
    wFee = 0.0;
    wFlag = "";
  }

  void insert(int userid, String coin, String address, String account, double amount, double fee, int confirm, String flag) {
    this.WalletAddress = address;
    this.WalletAccount = account;
    this.WalletCoin = coin;
    this.WalletFlag = flag;
    this.WalletAmount = amount;
    this.WalletFee = fee;
    this.WalletConfirm = confirm;
    this.WalletUser = userid;
  }

  String get WalletAddress => this.wAddress;
  String get WalletAccount => this.wAccount;
  String get WalletCoin => this.wCoin;
  String get WalletFlag => this.wFlag;
  double get WalletAmount => this.wAmount;
  double get WalletFee => this.wFee;
  int get WalletConfirm => this.wConfirm;
  int get WalletUser => this.wUID;

  void set WalletAddress(String address) {
    this.wAddress = address;
  }
  void set WalletAccount(String account) {
    this.wAccount = account;
  }
  void set WalletCoin(String coin) {
    this.wCoin = coin;
  }
  void set WalletFlag(String flag) {
    this.wFlag = flag;
    ;
  }
  void set WalletAmount(double amount) {
    this.wAmount = amount;
  }
  void set WalletFee(double fee) {
    this.wFee = fee;
  }
  void set WalletConfirm(int confirm) {
    this.wConfirm = confirm;
  }
  void set WalletUser(int userid) {
    this.wUID = userid;
  }

  void display() {
    print("Address: ${wAddress}");
    print("Account: ${wAccount}");
    print("Coin: ${wCoin}");
    print("Amount: ${wAmount}");
    print("Fee: ${wFee}");
    print("UID: ${wUID}");
    print("Flag: ${wFlag}");
  }
}
