import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/Label.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Service/Note_Service.dart';

class LabelManager extends StatefulWidget {
  @override
  _LabelManagerState createState() => _LabelManagerState();
}

class _LabelManagerState extends State<LabelManager> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NoteService _noteService = NoteService();
  late List<Map<String, dynamic>> _allLabels = new List.empty();
  String? userID;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    loadLabel();
    super.initState();
  }

  Future<void> loadLabel() async {
    try {
      User? user = _auth.currentUser;

      userID = user!.uid;

      Stream<QuerySnapshot> noteStream = FirebaseFirestore.instance
          .collection('labels')
          .where('uid', isEqualTo: user!.uid)
          .snapshots();

      await noteStream.listen((QuerySnapshot snapshot) {
        _allLabels = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          _allLabels = _allLabels;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void _addLabel(String label) {
    setState(() {
      Label newLabel = new Label(uid: userID!, nameLabel: label);
      _noteService.addLabel(newLabel);
    });
  }

  void _deleteLabel(String label) {
    setState(() {
      _noteService.deleteLabel(userID!, label);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Label Manager'),
      ),
      body: Column(
        children: [
          Expanded(
            child: !_allLabels.isEmpty
                ? ListView.builder(
                    itemCount: _allLabels.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = _allLabels[index];
                      Label label = Label(
                        nameLabel: data['nameLabel'],
                        uid: data['uid'],
                      );

                      return ListTile(
                        title: Text(data['nameLabel']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteLabel(data['nameLabel']),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('Not found labels'),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add label',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addLabel(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
