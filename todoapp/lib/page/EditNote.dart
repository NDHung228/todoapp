import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
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
import 'package:todoapp/model/Label.dart';
import 'package:todoapp/page/HomePage.dart';
import 'package:todoapp/page/LabelSelection.dart';
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
  late List<String> _label;
  late String _noteid;
  late String documentID;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Note note;
  String? imageURL = '';
  String? videoURL = '';
  File? imageFile;
  File? videoFile;
  File? audioFile;
  VideoPlayerController? _videoController;
  var chewieController;
  String? _audioURL = '';
  final _audioPlayer = AudioPlayer();
  bool isPlayingSound = false;
  Duration durationSound = Duration.zero;
  Duration position = Duration.zero;
  ImagePicker image = ImagePicker();
  bool _isLoading = false;
  List<String> _availableLabels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
    _label = widget.note.label;
    _noteid = widget.note.noteid;
    note = widget.note;

    imageURL = widget.note.imageURL ?? '';
    videoURL = widget.note.videoURL ?? '';
    _audioURL = widget.note.soundURL ?? '';

    print('audio ' + _audioURL.toString());
    if (_audioURL!.length != 0) {
      audioFile = File(_audioURL.toString());
    }

    if (videoURL != null) {
      _videoController = VideoPlayerController.network(
        videoURL!,
      )..initialize();
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: true,
        );
      });
    }

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlayingSound = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        durationSound = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

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

  Future<void> selectFileVideo() async {
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
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: true,
        );
      });
    });
  }

  void selectFileAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path.toString());
        _audioURL = result.files.single.path;
      });
    }
  }

  Future<void> loadData() async {
    try {
      List<Label> listLabel = await _noteService.getLabels();

      for (int i = 0; i < listLabel.length; i++) {
        setState(() {
          _availableLabels.add(listLabel[i].nameLabel ?? '');
        });
      }
    } catch (e) {
      print(e);
    }
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

  void onLabelsSelected(List<String> selectedLabels) {
    print('get data from ' + selectedLabels.length.toString());
    _label = selectedLabels;
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

  void _selectCategory(List<String> label) {
    setState(() {
      _label = label;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    chewieController.dispose();
    _videoController!.dispose();
  }

  void clearController() {
    _descriptionController.clear();
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Note'),),
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
                  label("label"),
                  SizedBox(
                    height: 12,
                  ),
                  LabelSelector(
                      allLabels: _availableLabels,
                      onLabelsSelected: onLabelsSelected,
                      selectedLabels: _label),
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
                  (imageURL!.length == 0 && imageFile == null)
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
                                image: NetworkImage(imageURL!),
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
                  (videoURL!.length == 0 && videoFile == null)
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
                  label('Audio'),
                  _buildAudio(),
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

  Widget _buildAudio() {
    return _audioURL?.length == 0 ? _buildFilePicker() : _buildAudioPlayer();
  }

  Widget _buildFilePicker() {
    return IconButton(
      icon: Icon(
        Icons.audiotrack,
        size: 60,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      onPressed: selectFileAudio,
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      if (!isPlayingSound) {
                        await _audioPlayer.play(UrlSource(_audioURL ?? ''));
                      } else {
                        await _audioPlayer.pause();
                      }
                    },
                    icon: isPlayingSound
                        ? Icon(Icons.stop)
                        : Icon(Icons.play_arrow)),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: durationSound.inSeconds.toDouble(),
                    activeColor: Colors.black,
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                      await _audioPlayer.resume();
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> uploadSound() async {
    String? downloadURL = '';

    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('sounds/${DateTime.now().toString()}');
      UploadTask uploadTask = storageRef.putFile(audioFile!);
      await uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
      });
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
    }
    return downloadURL;
  }

  void handleEditNote() async {
    setState(() {
      _isLoading = true;
    });
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String uid = user.uid;
    String title = _titleController.text;
    String description = _descriptionController.text;
    List<String> label = _label;
    if (imageFile != null) {
      imageURL = await uploadImage();
    }

    if (videoFile != null) {
      videoURL = await uploadVideo();
    }

    String soundURL;
    if (audioFile == null && _audioURL?.length == 0) {
      soundURL = '';
    } else {
      soundURL = await uploadSound() ?? '';
    }
    print('upload audio ' + soundURL);

    Note note = Note(
        title: title,
        description: description,
        label: label,
        uid: uid,
        noteid: _noteid,
        imageURL: imageURL,
        videoURL: videoURL,
        soundURL: soundURL,
        dayDelete: 1,
        isDelete: false);

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
