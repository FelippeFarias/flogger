import 'package:flogger/flogger.dart'; 

void main(){

  Flogger.d('Debug Hello World!');

  Flogger.w('Warning Hello World!');

  Flogger.e({"error":"msg error" , "status": 404});

  Flogger.i('Debug Hello World!');

}