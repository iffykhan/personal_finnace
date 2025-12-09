import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/signup_result_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
Future<SignupResult?> signupUser(
    String email, String password, String name) async {
  try {
    
    final UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    if (user == null) {
      throw Exception('Error while Signup');
    }
    await user.updateDisplayName(name);

    return SignupResult(uid: user.uid);
  } on FirebaseAuthException catch (e) {
    String message = 'An error occurred';
    if (e.code == 'email-already-in-use') {
      message = 'This email is already in use';
      return SignupResult(message: message);
    } else {
      message = e.message ?? 'Sign up failed. Please try again';
      return SignupResult(message: message);
    }
  } catch (e) {
    return SignupResult(message: e.toString());
  }
}
