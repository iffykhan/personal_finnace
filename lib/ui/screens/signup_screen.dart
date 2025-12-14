import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/signup_result_model.dart';
import 'package:personal_finance/providers/signup_provider.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';
import 'package:personal_finance/services/signup_page/signup_user_method.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});
  final formKey = GlobalKey<FormState>();
  
  

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final email = ref.watch(emailControllerProvider);
    final password=ref.watch(passwordControllerProvider);
    final cPassword= ref.watch(cpasswordControllerProvider);
    final name = ref.watch(nameControllerProvider);
    final boxHeight = ref.watch(signupBoxHeightProvider);
    return Stack(children: [
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
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormFeild(
                          controller: name,
                          hint: 'Enter your name',
                          isPassword: false,
                          prefixIcon: Icon(Icons.person),
                          keyboardType: TextInputType.name,
                          validator: nameValidator),
                      SizedBox(
                        height: 20,
                      ),
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
                          validator: passwordValidator),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormFeild(
                        controller: cPassword,
                        hint: 'Confirm password',
                        isPassword: true,
                        prefixIcon: Icon(Icons.lock_outline),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) =>
                            cpasswordValidator(value, password.text),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => singupPressed(ref,context),
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            minimumSize: Size(220, 38),
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 27,
                          ),
                          Text(
                            'Already Have an Account? ',
                            style: TextStyle(fontSize: 13.5),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteName.loginScreen);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 13.5, color: Colors.deepPurple),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
      Consumer(builder: (context,ref,_){
        final isLoading = ref.watch(signupIsloadingProvider);
        if (!isLoading) return SizedBox.shrink();
        return Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        );
      })
    ]
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
    if (input.length < 8) {
      return 'Passord length must be more than 8 letters.';
    }
    return null;
  }

  String? cpasswordValidator(String? input, String password) {
    if (input == null || input.isEmpty) {
      return 'Please enter confirm password';
    }
    if (input != password ) {
      return 'Password and confirm password doesn,t match';
    }
    return null;
  }

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  void singupPressed(WidgetRef ref, BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      ref.read(signupBoxHeightProvider.notifier).state=530;
      return;
    }
    ref.read(signupIsloadingProvider.notifier).state = true;

    final email = ref.read(emailControllerProvider);
    final password = ref.read(passwordControllerProvider);
    final name = ref.read(nameControllerProvider);

    try {
      final SignupAndLoginResult signupResult = await signupUser(
          email.text.trim(),
          password.text.trim(),
          name.text.trim());

      if (signupResult.uid != null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Signup Successfull')));
        Navigator.pushReplacementNamed(
            context, RouteName.dashboardScreen);
      }
      else if(signupResult.message != null){
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(signupResult.message!)));
      }
      else{
        if(!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exception occured')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ${e.toString()}')));
    }
    finally {
      ref.read(signupIsloadingProvider.notifier).state = false;
    }
  }
}
