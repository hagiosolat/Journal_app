import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/home_bloc.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider(
      {Key? key,
      required Widget child,
      required this.homeBloc,
      required this.uid})
      : super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant HomeBlocProvider oldWidget) {
    return homeBloc != oldWidget.homeBloc;
  }
}
