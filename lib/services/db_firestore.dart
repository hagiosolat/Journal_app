import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app4/models/journal.dart';
import 'package:journal_app4/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final _firestore = FirebaseFirestore.instance;
  final String _collectionJournals = 'journals';

  DbFirestoreService() {
    _firestore.settings;
  }

  @override
  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> journalDocs =
          snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();

      journalDocs.sort((comp1, comp2) => comp2.date!.compareTo(comp1.date!));

      return journalDocs;
    });
  }

  @override
  Future<bool> addJournal(Journal journal) async {
    DocumentReference documentReference =
        await _firestore.collection(_collectionJournals).add({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
      'uid': journal.uid,
    });
    //print(documentReference.id);
    return documentReference.id != null;
  }

  @override
  void updateJournal(Journal journal) async {
    print("journals sucessfully updated");
    print(journal.documentID);
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update({
      'date': journal.date,
      'mood': journal.mood,
      'note': journal.note,
    }).catchError((error) => print('Error updating: $error'));
  }

  @override
  void deleteJournal(Journal journal) async {
    await _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }
}
