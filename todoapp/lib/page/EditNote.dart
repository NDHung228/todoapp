import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/Service/Note_Service.dart';
import 'package:todoapp/page/HomePage.dart';
import 'package:video_player/video_player.dart';

import '../model/Note.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _category;
  late String _noteid;
  late String documentID;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Note note;
  String imageURL = '';
  String videoURL = '';
  File? imageFile;
  File? videoFile;
  VideoPlayerController? _videoController;
  var chewieController;

  ImagePicker image = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
    _category = widget.note.category;
    _noteid = widget.note.noteid;
    note = widget.note;

    imageURL = widget.note.imageURL ?? '';
    videoURL = widget.note.videoURL ?? '';
    print('test ' + videoURL);

    if (videoURL != null) {
      _videoController = VideoPlayerController.network(
        videoURL,
      )..initialize();
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: true,
        );
      });
    }

    getDocumentID(_noteid);
  }

  void getDocumentID(String noteid) async {
    DocumentSnapshot snapshot = await _db
        .collection('notes')
        .where('noteid', isEqualTo: noteid)
        .get()
        .then((value) => value.docs.first);
    documentID = snapshot.id;
  }

  void getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(img!.path);
    });
  }

  void selectFileVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4'],
    );
    if (result == null) return;
    setState(() {
      File c = File(result.files.single.path.toString());
      setState(() {
        videoFile = c;
        _videoController = VideoPlayerController.file(videoFile!)..initialize();
      });
      chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: true,
      );
    });
  }

  Future<String?> uploadVideo() async {
    String? downloadURL = '';

    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().toString()}');
      UploadTask uploadTask = storageRef.putFile(videoFile!);
      await uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
      });
    } on FirebaseException catch (e) {
      print('Error uploading video: $e');
    }
    return downloadURL;
  }

  Future<String?> uploadImage() async {
    String? downloadURL;

    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      if (imageFile != null) {
        UploadTask uploadTask = storageRef.putFile(imageFile!);
        await uploadTask.whenComplete(() async {
          downloadURL = await storageRef.getDownloadURL();
        });
      }
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
    }
    return downloadURL;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final NoteService _noteService = NoteService();

  void _selectCategory(String category) {
    setState(() {
      _category = category;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
  }

  void clearController() {
    _descriptionController.clear();
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 166, 215),
          Color.fromARGB(255, 224, 167, 199),
          Color.fromARGB(255, 221, 118, 175),
        ])),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Todo',
                    style: TextStyle(
                        fontSize: 33,
                        color: Colors.pinkAccent.shade400,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  label("Task Tittle"),
                  SizedBox(
                    height: 12,
                  ),
                  title(),
                  SizedBox(
                    height: 25,
                  ),
                  label("Category"),
                  SizedBox(
                    height: 12,
                  ),
                  Wrap(
                    runSpacing: 10,
                    children: [
                      chipData("Food", 0xffff6d6e),
                      SizedBox(width: 20),
                      chipData("WorkOut", 0xfff29732),
                      SizedBox(width: 20),
                      chipData("Work", 0xff6557ff),
                      SizedBox(width: 20),
                      chipData("Design", 0xff234ebd),
                      SizedBox(width: 20),
                      chipData("Run", 0xff2bc8d9),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  label("Description"),
                  SizedBox(
                    height: 12,
                  ),
                  description(),
                  SizedBox(
                    height: 50,
                  ),
                  label('Images'),
                  SizedBox(
                    height: 12,
                  ),
                  (imageURL.length == 0 && imageFile == null)
                      ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 90,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () {
                            getImage();
                          },
                        )
                      : imageFile == null
                          ? MaterialButton(
                              height: 100,
                              child: Image(
                                image: NetworkImage(imageURL),
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            )
                          : MaterialButton(
                              height: 100,
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            ),
                  SizedBox(
                    height: 50,
                  ),
                  label('Video'),
                  videoURL.length == 0
                      ? IconButton(
                          icon: Icon(
                            Icons.video_camera_back,
                            size: 90,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: () async {
                            selectFileVideo();
                          },
                        )
                      : MaterialButton(
                          height: 50,
                          minWidth: 10,
                          child: AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: Chewie(
                              controller: chewieController,
                            ),
                          ),
                          onPressed: () {
                            selectFileVideo();
                          },
                        ),
                  SizedBox(
                    height: 50,
                  ),
                  submitAdd(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget chipData(String label, int color) {
    return GestureDetector(
      onTap: () {
        _selectCategory(label);
      },
      child: Chip(
        backgroundColor: _category == null || _category != label
            ? Color(color)
            : Color(color).withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  void handleEditNote() async {
    setState(() {
      _isLoading = true;
    });
    User? user = _auth.currentUser;
    if (user == null) {
      // handle user not logged in
      return;
    }

    String uid = user.uid;
    String title = _titleController.text;
    String description = _descriptionController.text;
    String category = _category;
    String? imageURL = await uploadImage() ?? '';
    String? videoURL;
    if (videoFile == null) {
      videoURL = '';
    } else {
      videoURL = await uploadVideo();
      print('demo ' + videoURL.toString());
    }

    Note note = Note(
        title: title,
        description: description,
        category: category,
        uid: uid,
        noteid: _noteid,
        imageURL: imageURL,
        videoURL: videoURL);

    await _noteService.editNote(documentID, note);
    clearController();

    setState(() {
      _isLoading = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Widget submitAdd() {
    return InkWell(
      onTap: () {
        handleEditNote();
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 248, 80, 89),
              Color.fromARGB(255, 235, 34, 71)
            ],
          ),
        ),
        child: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.5,
                      letterSpacing: 0.2),
                ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 246, 230, 248),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          validator: (value) {
            if (value!.length < 5) {
              return 'Input must be at least 5 characters long';
            }
          },
          controller: _titleController,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Task Title",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
              contentPadding: EdgeInsets.only(
                left: 20,
                right: 20,
              )),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 246, 230, 248),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          validator: (value) {
            if (value!.length < 5) {
              return 'Input must be at least 5 characters long';
            }
          },
          controller: _descriptionController,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          maxLines: null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Task Title",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
              contentPadding: EdgeInsets.only(
                left: 20,
                right: 20,
              )),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Color.fromARGB(255, 221, 34, 162),
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2),
    );
  }
}
