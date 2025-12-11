import 'package:flutter_riverpod/flutter_riverpod.dart';

final isloadingProvider = StateProvider<bool>((ref){
  return false;
});

final signupBoxHeightProvider = StateProvider<double>((ref){
  return 440;
});