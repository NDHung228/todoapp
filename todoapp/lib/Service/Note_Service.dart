import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Note.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future<int> getNotesCount() async {
    final QuerySnapshot snapshot = await notesCollection.get();
    return snapshot.size;
  }

  Future<void> addNote(Note note) async {
    try {
      final int currentCount = await getNotesCount();
      await _db.collection('notes').add({
        'title': note.title,
        'description': note.description,
        'category': note.category,
        'uid': note.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'noteid': currentCount + 1,
        'password': '',
        'imageURL' : note.imageURL,
        'videoURL' : note.videoURL,
        'isDelete': note.isDelete,
        'dayDelete': note.dayDelete

      });

      DocumentSnapshot snapshot = await _db
                .collection('notes')
                .where('noteid', isEqualTo: currentCount + 1
                )
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
        'category': updatedNote.category,
        'uid': updatedNote.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'imageURL' : updatedNote.imageURL,
        'videoURL': updatedNote.videoURL,
        'isDelete': updatedNote.isDelete,
        'dayDelete':updatedNote.dayDelete
      });
    } catch (e) {
    
      print(e);
    }
  }

  Future<void> updateNoteID(String documentID, String noteid) async {
    try {
      await _db.collection('notes').doc(documentID).update({
        'timestamp': FieldValue.serverTimestamp(),
        'noteid': noteid
      });
    } catch (e) {
      
      print(e);
    }
  }

  Future<void> updatePass(String documentID, String pass) async {
    try {
      
      await _db.collection('notes').doc(documentID).update({
        'timestamp': FieldValue.serverTimestamp(),
        'password': pass
      });
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
