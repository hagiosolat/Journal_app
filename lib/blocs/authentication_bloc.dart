import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app4/services/authentication_api.dart';

class AuthenticationBloc {
  final AuthenticationApi? authenticationApi;

  final StreamController<String?> _authenticationController =
      StreamController<String?>();
  Sink<String?> get addUser => _authenticationController.sink;
  Stream<String?> get user => _authenticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc({this.authenticationApi}) {
    onAuthChanged();
  }

  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }

  void onAuthChanged() {
    FirebaseAuth auth = authenticationApi!.getFirebaseAuth();

    auth.authStateChanges().listen((event) {
      // final String uid = event?.uid;
      final String? uid = event != null ? event.uid : null;
      addUser.add(uid);
      print(uid);
    });

    //_logoutController.stream
    listLogoutUser.listen((logout) {
      if (logout == true) {
        _signOut();
      }
    });
  }

  void _signOut() {
    authenticationApi!.signOut();
  }
}
