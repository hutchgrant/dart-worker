// Copyright (c) 2015, Grant Hutchinson. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


import '../lib/ccserver.dart';

main(List<String> arguments){
  
  bool menu = true;
  if(arguments.length != 0){
     if(arguments[0] == "-server"){
      menu = false;
    } 
  }
  var server = new ccServer(menu);
}