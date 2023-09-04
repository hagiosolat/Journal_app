

abstract class AuthenticationApi{

  getFirebaseAuth();
  Future<String> currentUserid();
  Future<void> signOut();
  Future<String> signInWithEmailAndPassword({String email, String password});
  Future<String> createUserWithEmailAndPassword({String email, String password});
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}