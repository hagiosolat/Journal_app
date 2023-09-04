import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/authentication_bloc.dart';
import 'package:journal_app4/blocs/authentication_bloc_provider.dart';
import 'package:journal_app4/blocs/home_bloc.dart';
import 'package:journal_app4/blocs/home_bloc_provider.dart';
import 'package:journal_app4/pages/home.dart';
import 'package:journal_app4/services/authentication.dart';
import 'package:journal_app4/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:journal_app4/services/db_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = AuthenticationService();
    final AuthenticationBloc authenticationBloc =
        AuthenticationBloc(authenticationApi: authenticationService);

    return AuthenticationBlocProvider(
      authenticationBloc: authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightBlue,
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            print("The snapshot data is this .....${snapshot.data}");
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), authenticationService),
              uid: snapshot.data,
              child: _buildMaterialApp(const Home()),
            );
          } else {
            return _buildMaterialApp(const Login());
          }
        },
      ),
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        canvasColor: Colors.lightBlue.shade100,
        bottomAppBarColor: Colors.lightBlue,
      ),
      home: homePage,
    );
  }
}
