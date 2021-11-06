import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String title;
  bool check;
  late DocumentReference? reference;

  TodoModel({this.reference, this.title = '', this.check = false});

  factory TodoModel.fromDocument(DocumentSnapshot doc) {
    return TodoModel(
        reference: doc.reference, check: doc['check'], title: doc['title']);
  }

  Future save() async {
    if (reference == null) {
      int total = (await FirebaseFirestore.instance.collection('todo').get())
          .docs
          .length;
      reference = await FirebaseFirestore.instance
          .collection('todo')
          .add({'title': title, 'check': check, 'id': total + 1});
    } else {
      reference!.update({'title': title, 'check': check});
    }
  }

  Future delete() async {
    return reference!.delete();
  }
}
