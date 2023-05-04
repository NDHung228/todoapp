import 'package:flutter/material.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/Service/Auth_Service.dart';
import 'package:todoapp/page/TrashPage.dart';
import 'AddTodo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Change_Password.dart';
import 'EditNote.dart';
import '../model/Note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Service/Note_Service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NoteService _noteService = NoteService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  TextEditingController _textPassController = TextEditingController();
  TextEditingController _textConfirmController = TextEditingController();
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _newPassConfirmController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _changePassController = TextEditingController();
  var focus = FocusNode();
  List<Note> _notes = []; // List of all notes
  List<Note> _searchedNotes = []; // List of notes that match search query
  bool _searching = false;
  List<Note> notesList = [];
  var _formKey = GlobalKey<FormState>();
  late Stream<QuerySnapshot> _noteStream;
  late List<Map<String, dynamic>> _noteList;
  late List<Map<String, dynamic>> _allNotes;
  bool _isLoadData = false;
  bool _isListView = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    User? user = _auth.currentUser;
    Stream<QuerySnapshot> noteStream = FirebaseFirestore.instance
        .collection('notes')
        .where('uid', isEqualTo: user!.uid)
        .where('isDelete', isEqualTo: false)
        .snapshots();

    _noteStream = noteStream;

    noteStream.listen((QuerySnapshot snapshot) {
      _allNotes = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      _noteList = _allNotes;
      _noteList.sort((a, b) {
        Timestamp aTime = a['timestamp'];
        Timestamp bTime = b['timestamp'];
        return bTime.compareTo(aTime); // sort in descending order
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _textPassController.dispose();
    _textConfirmController.dispose();
    _oldPassController.dispose();
    _newPassConfirmController.dispose();
    _newPassController.dispose();
    _changePassController.dispose();
    super.dispose();
  }

  void clearController() {
    _textPassController.clear();
    _textConfirmController.clear();
    _oldPassController.clear();
    _newPassConfirmController.clear();
    _newPassController.clear();
    _changePassController.clear();
  }

  void _searchNotes(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      setState(() {
        _searching = false;
        _noteList = _allNotes;
      });
    } else {
      results = _allNotes
          .where((noteCur) =>
              noteCur["title"].toLowerCase().contains(query.toLowerCase()) ||
              noteCur["description"]
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      setState(() {
        _noteList = results;
        _searching = true;
      });
    }
  }

  void _savePassword(Note note) async {
    if (_formKey.currentState!.validate()) {
      DocumentSnapshot snapshot = await _db
          .collection('notes')
          .where('noteid', isEqualTo: note.noteid)
          .get()
          .then((value) => value.docs.first);

      _noteService.updatePassword(snapshot.id, _textPassController.text);

      Navigator.pop(context); // close dialog
      clearController();
    } else {}
  }

  void enterPassword(note) {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context); // close dialog
      // handleEdit(note);
      clearController();
    }
  }

  Widget DrawerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: const Text('Recycle bin'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrashPage(noteList: _allNotes),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _homeAppBar(),
      drawer: DrawerMenu(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(children: [
              Expanded(
                child: homeWidget(),
              ),
            ]),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 107, 108, 159),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
            backgroundColor: Color.fromARGB(255, 107, 108, 159),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Color.fromARGB(255, 107, 108, 159),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
            backgroundColor: Color.fromARGB(255, 107, 108, 159),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget homeWidget() {
    if (_selectedIndex == 1) {
      _isLoadData = false;
      return AddTodoPage();
    } else if (_selectedIndex == 0) {
      if (!_isLoadData) {
        loadData();
        _isLoadData = true;
      }
      return Column(
        children: [
          searchBox(onChanged: _searchNotes),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _noteStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No notes found'));
                }
                return !_noteList.isEmpty
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: _noteList.length,
                        itemBuilder: _buildItem,
                      )
                    : Center(child: Text('No any notes found'));
              },
            ),
          )
        ],
      );
    } else if (_selectedIndex == 3) {
      _isLoadData = false;
      return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChangePassword();
              }));
            },
            child: Text(
              "Change Password",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            )),
      );
    }
    _isLoadData = false;
    return AddTodoPage();
  }

  Widget buildView() {
    if (_isListView) {
      return ListView.builder(
        itemCount: _noteList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = _noteList[index];
          Note note = Note(
              title: data['title'],
              description: data['description'],
              category: data['category'],
              uid: data['uid'],
              noteid: data['noteid'],
              password: data['password'],
              imageURL: data['imageURL']);
          return slidableNote(note);
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          // return a widget for each item in the grid
        },
      );
    }
  }

  Widget _buildItem(context, index) {
    Map<String, dynamic> data = _noteList[index];
    Note note = Note(
        title: data['title'],
        description: data['description'],
        category: data['category'],
        uid: data['uid'],
        noteid: data['noteid'],
        password: data['password'],
        imageURL: data['imageURL']);
    return gridCard(note);
  }

  Widget gridCard(Note note) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('${note.title}'),
            subtitle: Text('${note.description}'),
          )
        ],
      ),
    );
  }

  Widget slidableNote(Note note) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: (note.password!.length == 0)
              ? [
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
                  SlidableAction(
                    onPressed: (context) => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return savePasswordDialog(note);
                      },
                    ),
                    backgroundColor: Color.fromARGB(255, 43, 87, 124),
                    foregroundColor: Colors.white,
                    icon: Icons.lock,
                    label: 'Protect',
                  ),
                ]
              : [
                  SlidableAction(
                    onPressed: (context) => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return passDialogForDelete(note);
                      },
                    ),
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (context) => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return changePassNoteDialog(note);
                      },
                    ),
                    backgroundColor: Color.fromARGB(255, 43, 87, 124),
                    foregroundColor: Colors.white,
                    icon: Icons.lock_clock_outlined,
                    label: 'Change pass',
                  ),
                  SlidableAction(
                    onPressed: (context) => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return unPassDialog(note);
                      },
                    ),
                    backgroundColor: Color.fromARGB(255, 43, 87, 124),
                    foregroundColor: Colors.white,
                    icon: Icons.lock_open_outlined,
                    label: 'Remove pass',
                  )
                ],
        ),
        child: ListTile(
          title: Row(
            children: [
              Text(note.title.toString()),
              note.password != null && note.password!.isNotEmpty
                  ? Icon(Icons.lock)
                  : SizedBox(),
            ],
          ),
          subtitle: Text(note.description.toString()),
          trailing: Text(note.category.toString()),
          onTap: () {
            if (note.password!.length != 0) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return passDialog(note);
                },
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
            }
          },
        ));
  }

  bool _validatePassword(String password) {
    if (_formKey.currentState!.validate()) {
      // Password is valid, compare it to the note's password
      return _oldPassController.text == password;
    } else {
      // Password is not valid, show an error message
      return false;
    }
  }

  Widget passDialog(Note note) {
    return AlertDialog(
      title: Text('Enter password'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _oldPassController,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (note.password != _oldPassController.text) {
              return 'Password incorrect';
            }
            return null;
          },
          maxLines: 1,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            clearController();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            bool passwordCorrect = _validatePassword(note.password.toString());
            if (passwordCorrect) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
              clearController();
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }

  Widget passDialogForDelete(Note note) {
    return AlertDialog(
      title: Text('Enter password'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _oldPassController,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (note.password != _oldPassController.text) {
              return 'Password incorrect';
            }
            return null;
          },
          maxLines: 1,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            clearController();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            bool passwordCorrect = _validatePassword(note.password.toString());
            if (passwordCorrect) {
              DocumentSnapshot snapshot = await _db
                  .collection('notes')
                  .where('noteid', isEqualTo: note.noteid)
                  .get()
                  .then((value) => value.docs.first);
              _noteService.deleteNoteById(snapshot.id);
              Navigator.pop(context);
              clearController();
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }

  Widget searchBox({required Function(String) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void openDrawer(ScaffoldState scaffoldState) {
    scaffoldState.openDrawer();
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
            note.isDelete = true;
            _noteService.editNote(note.noteid, note);
            Navigator.pop(context);
          },
          child: Text('DELETE'),
        ),
      ],
    );
  }

  AppBar _homeAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isListView = !_isListView;
            });
          },
          child: Text(
            _isListView ? 'Switch to Grid View' : 'Switch to List View',
            style: TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: () async {
            // Show a drop-down menu with one option: "Log Out"
            final result = await showMenu(
              context: context,
              position: RelativeRect.fromLTRB(900, 80, 0, 0),
              items: [
                PopupMenuItem(
                  child: Text('Log Out'),
                  value: 'logout',
                ),
              ],
            );
            // If the user tapped "Log Out", sign out and navigate to the login screen
            if (result == 'logout') {
              await authClass.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => MyApp()),
                (route) => false,
              );
            }
          },
          child: Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/person.jpg'),
            ),
          ),
        )
      ]),
    );
  }

  AlertDialog savePasswordDialog(Note note) {
    return AlertDialog(
      title: Text("Set Password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              controller: _textPassController,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your password';
                if (v.length < 4) return 'Password must have 4+ characters';
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _textConfirmController,
              obscureText: true,
              focusNode: focus,
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Please enter confirm your password';
                if (v.length < 4) return 'Password must have 4+ characters';
                if (_textPassController.text != _textConfirmController.text)
                  return 'Confirm password is not correct';
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            _savePassword(note);
          },
          child: Text("Protect"),
        ),
      ],
    );
  }

  AlertDialog changePassNoteDialog(Note note) {
    return AlertDialog(
      title: Text("Change Password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              controller: _textPassController,
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Please enter your old password';
                if (v.length < 4) return 'Password must have 4+ characters';
                if (note.password != _textPassController.text)
                  return 'Old password is not correct';
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Old Password',
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _newPassController,
              obscureText: true,
              focusNode: focus,
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Please enter your new password';
                if (v.length < 4) return 'Password must have 4+ characters';
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Password',
              ),
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _newPassConfirmController,
              obscureText: true,
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Please enter confirm your password';
                if (v.length < 4) return 'Password must have 4+ characters';
                if (_newPassController.text != _newPassConfirmController.text)
                  return 'Confirm new password is not correct';
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm new password',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            clearController();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              DocumentSnapshot snapshot = await _db
                  .collection('notes')
                  .where('noteid', isEqualTo: note.noteid)
                  .get()
                  .then((value) => value.docs.first);

              String newPass = _newPassController.text.toString();
              _noteService.updatePass(snapshot.id, newPass);
              Navigator.of(context).pop();
              clearController();
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  AlertDialog unPassDialog(Note note) {
    return AlertDialog(
      title: Text("UnProtected"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              controller: _textPassController,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your password';
                if (v.length < 4) return 'Password must have 4+ characters';
                if (note.password != _textPassController.text)
                  return 'Your password is not correct';
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            clearController();
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              DocumentSnapshot snapshot = await _db
                  .collection('notes')
                  .where('noteid', isEqualTo: note.noteid)
                  .get()
                  .then((value) => value.docs.first);

              _noteService.updatePass(snapshot.id, '');
              Navigator.pop(context);
              clearController();
            }
          },
          child: Text("Remove password"),
        ),
      ],
    );
  }
}
