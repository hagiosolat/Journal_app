import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/journal_edit_bloc.dart';

class JournalEditBlocProvider extends InheritedWidget {
  final JournalEditBloc? journalEditBloc;

  const JournalEditBlocProvider({Key? key, Widget? child, this.journalEditBloc})
      : super(key: key, child: child as Widget);

  static JournalEditBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JournalEditBlocProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant JournalEditBlocProvider oldWidget) {
    return journalEditBloc != oldWidget.journalEditBloc;
  }
}
