class Journal {
  String? documentID;
  String? date;
  String? mood;
  String? note;
  String? uid;

  Journal({
    this.documentID,
    this.date,
    this.mood,
    this.note,
    this.uid,
  });

  factory Journal.fromDoc(dynamic doc) => Journal(
      documentID: doc.id,
      date: doc.data()["date"],
      mood: doc.data()["mood"],
      note: doc.data()["note"],
      uid: doc.data()["uid"]);
}
