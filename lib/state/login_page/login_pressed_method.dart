import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/signup_page/signup_result_model.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/services/login_page/login_user_method.dart';
import 'package:personal_finance/state/providers/login_providers.dart';


void loginPressed(WidgetRef ref, BuildContext context, dynamic formKey) async {
  if (!formKey.currentState!.validate()) {
    ref.read(loginBoxHeightProvider.notifier).state = 500;
    return;
  }
  final email = ref.read(emailControllerProvider);
  final password = ref.read(passwordControllerProvider);

  ref.read(loginIsloadingProvider.notifier).state = true;
  try {
    final SignupAndLoginResult loginResult =
        await loginUser(email.text.trim(), password.text.trim());

    if (loginResult.uid != null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login successfully')));
      ref.read(loginIsloadingProvider.notifier).state = false;
      Navigator.pushReplacementNamed(context, RouteName.dashboardScreen);
    } else if (loginResult.message != null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(loginResult.message!)));
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Exception occured')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error ${e.toString()}')));
  } finally {
    ref.read(loginIsloadingProvider.notifier).state = false;
  }
}
