import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupIsloadingProvider = StateProvider<bool>((ref){
  return false;
});

final signupBoxHeightProvider = StateProvider<double>((ref){
  return 440;
});

final emailControllerProvider = Provider((ref){
  final email = TextEditingController();
  ref.onDispose((){
    email.dispose();
  });
  return email;
});


final passwordControllerProvider = Provider((ref){
  final password = TextEditingController();
  ref.onDispose((){
    password.dispose();
  });
  return password;
});

final cpasswordControllerProvider = Provider<TextEditingController>((ref){
  final cpassword = TextEditingController();
  ref.onDispose((){
    cpassword.dispose();
  });
  return cpassword;
});

final nameControllerProvider = Provider<TextEditingController>((ref){
  final name = TextEditingController();
  ref.onDispose((){
    name.dispose();
  });
  return name;
});