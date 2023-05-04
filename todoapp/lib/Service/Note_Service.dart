import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/Note.dart';
import '../model/Label.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late List<Map<String, dynamic>> _allNotes;

  Future<int> getNotesCount() async {
    final QuerySnapshot snapshot = await notesCollection.get();
    return snapshot.size;
  }

  Future<void> addLabel(Label label) async {
    try {
      await _db.collection('labels').add({
        'nameLabel': label.nameLabel,
        'uid': label.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getNotesByLabel(String label) async {
    User? user = _auth.currentUser;
    Stream<QuerySnapshot> noteStream = FirebaseFirestore.instance
        .collection('notes')
        .where('uid', isEqualTo: user!.uid)
        .where('isDelete', isEqualTo: false)
        .snapshots();

    noteStream.listen((QuerySnapshot snapshot) {
      _allNotes = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      _allNotes.sort((a, b) {
        Timestamp aTime = a['timestamp'];
        Timestamp bTime = b['timestamp'];
        return bTime.compareTo(aTime); // sort in descending order
      });
    });
    // List<Map<String, dynamic>> listNote = [];

    // for (int i = 0; i < _allNotes.length; i++) {
    //   Map<String, dynamic> data = _allNotes[i];
    //   List<String> listLabels = data['label'];
    //   for (int j = 0; j < listLabels.length; j++) {
    //     if (listLabels[j] == label) {
    //       listNote.add(_allNotes[i]);
    //     }
    //   }
    // }
    return _allNotes;
  }

  Future<void> deleteLabel(String uid, String nameLabel) async {
    try {
      await FirebaseFirestore.instance
          .collection('labels')
          .where('uid', isEqualTo: uid)
          .where('nameLabel', isEqualTo: nameLabel)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Label>> getLabels() async {
    List<Label> labels = [];

    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('labels')
        .where('uid', isEqualTo: uid)
        .get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        Label label = Label.fromMap(data);
        labels.add(label);
      }
    });

    return labels;
  }

  Future<void> addNote(Note note) async {
    try {
      final int currentCount = await getNotesCount();
      await _db.collection('notes').add({
        'title': note.title,
        'description': note.description,
        'label': note.label,
        'uid': note.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'noteid': currentCount + 1,
        'password': '',
        'imageURL': note.imageURL,
        'videoURL': note.videoURL,
        'soundURL': note.soundURL,
        'isDelete': note.isDelete,
        'dayDelete': note.dayDelete
      });

      DocumentSnapshot snapshot = await _db
          .collection('notes')
          .where('noteid', isEqualTo: currentCount + 1)
          .get()
          .then((value) => value.docs.first);
      updateNoteID(snapshot.id, snapshot.id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> editNote(String documentID, Note updatedNote) async {
    try {
      await _db.collection('notes').doc(documentID).update({
        'title': updatedNote.title,
        'description': updatedNote.description,
        'label': updatedNote.label,
        'uid': updatedNote.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'imageURL': updatedNote.imageURL,
        'videoURL': updatedNote.videoURL,
        'soundURL': updatedNote.soundURL,
        'isDelete': updatedNote.isDelete,
        'dayDelete': updatedNote.dayDelete
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateNoteID(String documentID, String noteid) async {
    try {
      await _db.collection('notes').doc(documentID).update(
          {'timestamp': FieldValue.serverTimestamp(), 'noteid': noteid});
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePass(String documentID, String pass) async {
    try {
      await _db.collection('notes').doc(documentID).update(
          {'timestamp': FieldValue.serverTimestamp(), 'password': pass});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNoteById(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePassword(String documentId, String newPassword) async {
    try {
      await _db.collection('notes').doc(documentId).update({
        'password': newPassword,
      });
    } catch (e) {
      print(e);
    }
  }
}
