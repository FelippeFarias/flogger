import 'package:flogger/flogger.dart'; 

void main(){
  var log = Flogger();

  log.d(DateTime.now());

  log.w('Warning Hello World!',tag: 'CustomTag');

  log.e({"error":"msg error" , "status": 404});

  log.i('Info Hello World!');

}