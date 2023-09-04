import 'dart:async';
import 'package:journal_app4/services/authentication_api.dart';
import 'package:journal_app4/services/db_firestore_api.dart';
import 'package:journal_app4/models/journal.dart';

class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  final StreamController<List<Journal>> _journalController =
      StreamController<List<Journal>>.broadcast();
  Sink<List<Journal>> get _addListJournal => _journalController.sink;
  Stream<List<Journal>> get listJournal => _journalController.stream;

  final StreamController<Journal> _journalDeleteController =
      StreamController<Journal>.broadcast();
  Sink<Journal> get deleteJournal => _journalDeleteController.sink;

  HomeBloc(this.dbApi, this.authenticationApi) {
    _startListeners();
  }

  void _startListeners() async {
    //Retrieve Firestore Journal Records as List<Journal> not DocumentSnapshot
    String id = await authenticationApi.currentUserid();
    print(id);
    if (!_journalController.isClosed) {
      dbApi.getJournalList(id).listen((journaldoc) {
        _addListJournal.add(journaldoc);
      });
    }
    _journalDeleteController.stream.listen((journal) {
      dbApi.deleteJournal(journal);
    });

  }

  void dispose() {
    _journalController.close();
    _journalDeleteController.close();
  }
}
