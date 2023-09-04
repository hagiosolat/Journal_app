import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc? authenticationBloc;

  const AuthenticationBlocProvider({Key? key, Widget? child, this.authenticationBloc}) :
   super(key: key, child: child as Widget);

  static AuthenticationBlocProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant AuthenticationBlocProvider oldWidget) {
   return authenticationBloc != oldWidget.authenticationBloc;
  }
}