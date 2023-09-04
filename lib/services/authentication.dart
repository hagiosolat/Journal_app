import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app4/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String> currentUserid() async {
    User? user = _firebaseAuth.currentUser;
    return user!.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      {String? email, String? password}) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email as String, password: password as String);
    return user.user!.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      {String? email, String? password}) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email as String, password: password as String);
    return user.user!.uid;
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    user!.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    return user!.emailVerified;
  }
}
