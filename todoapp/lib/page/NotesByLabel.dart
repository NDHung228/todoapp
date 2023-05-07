import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todoapp/Service/Note_Service.dart';
import 'package:todoapp/model/Label.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/model/Note.dart';

class NotesByLabel extends StatefulWidget {
  final String label;
  NotesByLabel({required this.label});

  @override
  State<NotesByLabel> createState() => _NotesByLabelState();
}

class _NotesByLabelState extends State<NotesByLabel> {
  String label = '';
  final NoteService _noteService = NoteService();
  List<String> allNotes = [];
  late List<Map<String, dynamic>> _notesByLabel = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> listNote = [];

  @override
  void initState() {
    super.initState();
    loadData(widget.label);
  }

  Future<void> loadData(String label) async {
    this.label = label;

    try {
      User? user = _auth.currentUser;
      Stream<QuerySnapshot> noteStream = FirebaseFirestore.instance
          .collection('notes')
          .where('uid', isEqualTo: user!.uid)
          .where('isDelete', isEqualTo: false)
          .where('label',arrayContains: label)
          .snapshots();

      await noteStream.listen((QuerySnapshot snapshot) {
        _notesByLabel = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        setState(() {
          _notesByLabel = _notesByLabel;
        });
        _notesByLabel.sort((a, b) {
          Timestamp aTime = a['timestamp'];
          Timestamp bTime = b['timestamp'];
          return bTime.compareTo(aTime); // sort in descending order
        });
      });

      for (int i = 0; i < _notesByLabel.length; i++) {
        Map<String, dynamic> data = _notesByLabel[i];
        List<String> listLabels = data['label'];
        for (int j = 0; j < listLabels.length; j++) {   
          if (listLabels[j] == label) {
            listNote.add(_notesByLabel[i]);
          }
        }
      }
    } catch (e) {
      print(e);
    }

    // List<Map<String, dynamic>> getNotes = [];
    // getNotes = await _noteService.getNotesByLabel(label);

    // print('test ' + getNotes.length.toString());
    // setState(() {
    //   _notesByLabel = getNotes;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: ListView.builder(
        itemCount: _notesByLabel.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = _notesByLabel[index];

          return ListTile(
            title: Text(data['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotesByLabel(label: data['description']),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget slidableNote(Note note) {
    return Scaffold();
  }
}
