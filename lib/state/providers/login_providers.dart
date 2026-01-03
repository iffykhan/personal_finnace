import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Card Height
final loginBoxHeightProvider = StateProvider<double>((ref){
  return 410;
});

//Loading indicator
final loginIsloadingProvider = StateProvider<bool>((ref){
  return false;
});

//Email Controller
final emailControllerProvider = Provider.autoDispose<TextEditingController>((ref){
  final emailController = TextEditingController();
  
  ref.onDispose((){
    emailController.dispose();
  });
  return emailController;
});

final passwordControllerProvider = Provider.autoDispose<TextEditingController>((ref){
  final passwordController = TextEditingController();
  ref.onDispose((){
   passwordController.dispose();
  });
  return passwordController;
});