// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library dbconnect;

import 'objects/dbobj.dart';
import 'objects/wallet.dart';
import 'package:sqljocky/sqljocky.dart';

class dbConnect {

  String USER, PASS, IP, NAME;
  int PORT;
  var con;

  dbConnect(dbObj db) {
    USER = db.ServerUser;
    PASS = db.ServerPass;
    IP = db.ServerIP;
    NAME = db.ServerDatabaseName;
    PORT = 3306;
    init();
  }

  void init() {
    con = new ConnectionPool(host: '${IP}', port: PORT, user: '${USER}', password: '${PASS}', db: '${NAME}', max: 5);
  }

  void updateConfirmedBalance(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_balance SET coin_balance = ? WHERE uid = ? AND coin_code = ?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletUser, wall.WalletCoin]).then((result) {
      });
    });
  }
  void updatePendingBalance(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_balance SET coin_pending = ? WHERE uid = ? AND coin_code = ?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletUser, wall.WalletCoin]).then((result) {
        print(result);
      });
    });
  }
  void updateWithdrawBalance(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_balance SET coin_withdraw = ? WHERE uid = ? AND coin_code = ?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletUser, wall.WalletCoin]).then((result) {
        print(result);
      });
    });
  }
  void updateAutopayBalance(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_balance SET coin_autopay = ?, coin_autoaddress WHERE uid = ? AND coin_code = ?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletAddress, wall.WalletUser, wall.WalletCoin]).then((result) {
        print(result);
      });
    });
  }
  void updateConfirmedWallet(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_wallets SET balance_total = ? WHERE uid = ? AND coins_enabled = ? AND walletaddress =?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletUser, wall.WalletCoin, wall.WalletAddress]).then((result) {
        print(result);
      });
    });
  }
  void addDefaultWallet(wallet wall) {
    init();
    con.prepare('INSERT into ccdev_wallets (basic_id, bundle_type, uid, orderid, balance_total, pending_total, fee_total, coins_enabled, walletaddress, walletaccount, last_processed_id, confirm, count, flag, timestamp) values (NULL, "ccdev_coin", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())').then((query) {
      query.execute([wall.WalletUser, 0, 0.0, 0.0, 0.0, wall.WalletCoin, wall.WalletAddress, wall.WalletAccount, 0, 0, 0, "n/a"]).then((result) {
      });
    });
  }
  void updatePendingWallet(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_wallets SET pending_total = ? WHERE uid = ? AND coins_enabled = ? AND walletaddress =?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletUser, wall.WalletCoin, wall.WalletAddress]).then((result) {
        print(result);
      });
    });
  }
  void updateConfirmedTransaction(wallet wall) {
    init();
    con.prepare('UPDATE ccdev_transactions SET amount = ? WHERE uid = ? AND coin = ? AND tranid = ?').then((query) {
      query.execute([wall.WalletAmount, wall.WalletUser, wall.WalletCoin, wall.WalletAddress]).then((result) {
        print(result);
      });
    });
  }
}
