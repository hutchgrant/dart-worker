
import "dart:core";


class Caesar {
  int _key;
 
  Caesar(this._key);
 
  int _toCharCode(String s) {
    return s.codeUnitAt(0);
  }
 
  String _fromCharCode(int ch) {
    return new String.fromCharCodes([ch]);
  }
 
  String _process(String msg, int offset) {
    StringBuffer sb=new StringBuffer();
    for(int i=0;i<msg.length;i++) {
      int ch=msg.codeUnitAt(i);
      if(ch>=_toCharCode('A')&&ch<=_toCharCode('Z')) {
        sb.write(_fromCharCode(_toCharCode("A")+(ch-_toCharCode("A")+offset)%26));
      }
      else if(ch>=_toCharCode('a')&&ch<=_toCharCode('z')) {
        sb.write(_fromCharCode(_toCharCode("a")+(ch-_toCharCode("a")+offset)%26));
      }else if(ch>=_toCharCode('0')&&ch<=_toCharCode('9')) {
        sb.write(_fromCharCode(_toCharCode("0")+(ch-_toCharCode("0")+offset)%26));
      }else {
        sb.write(msg[i]);
      }
    }
    return sb.toString();
  }
 
  String encrypt(String msg) {
    return _process(msg, _key);
  }
 
  String decrypt(String msg) {
    return _process(msg, 26-_key);
   }
}
 