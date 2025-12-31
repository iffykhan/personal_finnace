import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/signup_page/signup_result_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<SignupAndLoginResult> loginUser(String email,String password) async {
  try {
    final UserCredential userCredential = await
    auth.signInWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    if(user == null){
      return SignupAndLoginResult(message: 'Unable to login, database was unable to provide the login information');
    }
    return SignupAndLoginResult(uid: user.uid);
    // Return uid if successfully login



  } on FirebaseAuthException catch (e){
    return SignupAndLoginResult(message: e.code);
  }
  catch (e){
    return SignupAndLoginResult(message: 'unknown-error');
  }
}