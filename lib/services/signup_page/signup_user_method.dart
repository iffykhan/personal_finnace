import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/signup_result_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
Future<SignupAndLoginResult> signupUser(
    String email, String password, String name) async {
  try {
    final UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    if (user == null) {
      return SignupAndLoginResult(message: 'Unable to Signup, database was unable to create user and provide information');
    }
    await user.updateDisplayName(name);
    return SignupAndLoginResult(uid: user.uid);
    // Return uid if successfully sigup



  } on FirebaseAuthException catch (e) {
   return SignupAndLoginResult(message: e.code);
  } catch (e) {
    return SignupAndLoginResult(message: 'unknown-error');
  }
}
