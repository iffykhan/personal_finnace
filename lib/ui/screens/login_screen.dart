import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/signup_result_model.dart';
import 'package:personal_finance/services/login_page/login_user_method.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../providers/login_providers.dart';
import '../../routes/screen_routes.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final password=ref.watch(passwordControllerProvider);
    final email=ref.watch(emailControllerProvider);
    final boxHeight = ref.watch(loginBoxHeightProvider);
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: boxHeight,
              child: SingleChildScrollView(
                child: Card(
                  elevation: 20,
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text('Login',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple)),
                          ),
                          SizedBox(height: 20),
                          CustomTextFormFeild(
                              controller: email,
                              hint: 'Enter your email',
                              isPassword: false,
                              prefixIcon: Icon(Icons.email),
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidator),
                          SizedBox(height: 20),
                          CustomTextFormFeild(
                            controller: password,
                            hint: 'Enter your password',
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock),
                            keyboardType: TextInputType.visiblePassword,
                            validator: passwordValidator,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(fontSize: 13.5),
                                )),
                          ),
                          ElevatedButton(
                            onPressed: () => loginPressed(ref,context),
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                minimumSize: Size(220, 38),
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Text('Or'),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: SignInButton(
                              elevation: 3,
                              Buttons.Google,
                              onPressed: () {},
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RouteName.signupScreen);
                              },
                              child: Text(
                                'Don\'t have an account Sign Up',
                                style: TextStyle(fontSize: 13.5),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
          
          Consumer(
              builder: (context,ref,_){
            final isloading=ref.watch(loginIsloadingProvider);
            if(!isloading) return SizedBox.shrink();
            return Positioned.fill(child: Container(
              color: Colors.black54,
              child: Center(
                  child: CircularProgressIndicator()),
            ));
          })
      ],
    );
  }

  String? emailValidator(String? input) {
    if (input == null || input.toString().isEmpty) {
      return 'Enter email';
    }
    final emailRegix = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegix.hasMatch(input.toString())) {
      return 'Enter valid email';
    }
    return null;
  }

  String? passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Enter you password';
    }
    return null;
  }

   void loginPressed(WidgetRef ref,BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      ref.read(loginBoxHeightProvider.notifier).state=500;
      return;
    }
    final email = ref.read(emailControllerProvider);
    final password = ref.read(passwordControllerProvider);

    ref.read(loginIsloadingProvider.notifier).state=true;
    try {
      final SignupAndLoginResult loginResult = await loginUser(
          email.text.trim(), password.text.trim());

      if (loginResult.uid != null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successfully')));
        ref
            .read(loginIsloadingProvider.notifier)
            .state = false;
        Navigator.pushReplacementNamed(
            context, RouteName.dashboardScreen);
      }
      else if (loginResult.message != null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loginResult.message!)));
      }
      else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exception occured')));
      }
    }
    catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ${e.toString()}')));
    }
    finally {
     ref.read(loginIsloadingProvider.notifier)
     .state = false;
   }
  }
}
