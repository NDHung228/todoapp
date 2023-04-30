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
        'password': ''

      });
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
        
      });
    } catch (e) {
      print('can not find');
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
      print('can not find');
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
