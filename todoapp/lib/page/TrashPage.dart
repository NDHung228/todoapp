import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/model/Note.dart';
import '../Service/Note_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrashPage extends StatefulWidget {
  late List<Map<String, dynamic>> noteList;
  TrashPage({required this.noteList});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  late List<Map<String, dynamic>> noteList;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final NoteService _noteService = NoteService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Map<String, dynamic>> allNotes;
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allNotes = widget.noteList;
    noteList = allNotes;
    deleteNoteTime();
    loadData();
  }

  void deleteNoteTime() async {
    List<Map<String, dynamic>> result;
    User? user = _auth.currentUser;
    Stream<QuerySnapshot> noteStream = FirebaseFirestore.instance
        .collection('notes')
        .where('uid', isEqualTo: user!.uid)
        .where('isDelete', isEqualTo: true)
        .snapshots();

    noteStream.listen((QuerySnapshot snapshot) {
      result = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (int i = 0; i < result.length; i++) {
        Map<String, dynamic> data = result[i];
        Note note = Note(
            title: data['title'],
            description: data['description'],
            label: data['label'],
            uid: data['uid'],
            noteid: data['noteid'],
            password: data['password'],
            imageURL: data['imageURL'],
            videoURL: data['videoURL'],
            isDelete: data['isDelete'],
            timestamp: data['timestamp'],
            dayDelete: data['dayDelete']);
        final timeNow = DateTime.now();
        DateTime timeNote = note.timestamp!.toDate();
        final noteDate = DateTime(2023, 4, 30);
        final daysGap = timeNow.difference(timeNote).inDays;

        print('test1 ' + timeNow.difference(timeNote).inDays.toString());
        print('test2 ' + timeNow.difference(noteDate).inDays.toString());
        int? dayDelete = note.dayDelete;
        print('test3 '+dayDelete.toString());

        if (daysGap >= dayDelete!) {
          _noteService.deleteNoteById(note.noteid);
        }
      }
    });
  }

  void loadData() {
    User? user = _auth.currentUser;
    Stream<QuerySnapshot> noteStream = FirebaseFirestore.instance
        .collection('notes')
        .where('uid', isEqualTo: user!.uid)
        .where('isDelete', isEqualTo: true)
        .snapshots();

    noteStream.listen((QuerySnapshot snapshot) {
      allNotes = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        noteList = allNotes;
      });
      noteList.sort((a, b) {
        Timestamp aTime = a['timestamp'];
        Timestamp bTime = b['timestamp'];
        return bTime.compareTo(aTime); // sort in descending order
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin'),
      ),
      body: !noteList.isEmpty
          ? ListView.builder(
              itemCount: noteList
                  .length, // Replace with the actual number of notes in the recycle bin
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = noteList[index];
                Note note = Note(
                    title: data['title'],
                    description: data['description'],
                    label: data['label']?? '',
                    uid: data['uid'],
                    noteid: data['noteid'],
                    password: data['password'],
                    imageURL: data['imageURL'],
                    videoURL: data['videoURL'],
                    isDelete: data['isDelete']);
                return slidableNote(note);
              },
            )
          : Center(child: Text('No any notes found')),
    );
  }

  AlertDialog deleteNoteDialog(Note note) {
    return AlertDialog(
      title: Text('Delete Note'),
      content: Text('Are you sure you want to delete this note?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            DocumentSnapshot snapshot = await _db
                .collection('notes')
                .where('noteid', isEqualTo: note.noteid)
                .get()
                .then((value) => value.docs.first);
            _noteService.deleteNoteById(snapshot.id);
            Navigator.pop(context);
          },
          child: Text('DELETE'),
        ),
      ],
    );
  }

  AlertDialog restoreNoteDialog(Note note) {
    return AlertDialog(
      title: Text('Resorte Note'),
      content: Text('Are you you want to restore this note?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            note.isDelete = false;
            _noteService.editNote(note.noteid, note);
            Navigator.pop(context);
          },
          child: Text('CONFIRM'),
        ),
      ],
    );
  }

  Widget slidableNote(Note note) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return deleteNoteDialog(note);
                },
              ),
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
          trailing: IconButton(
            icon: Icon(Icons.restore_from_trash),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return restoreNoteDialog(note);
                },
              );
            },
          ),
        ));
  }
}
