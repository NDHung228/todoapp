import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/model/Label.dart';
import 'package:video_player/video_player.dart';
import '../model/Note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Service/Note_Service.dart';
import 'HomePage.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chewie/chewie.dart';
import 'LabelSelection.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? imageFile;
  File? videoFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ImagePicker image = ImagePicker();
  bool _isLoading = false;
  UploadTask? uploadTask;
  VideoPlayerController? _videoController;
  var chewieController;
  String? _audioURL;
  File? audioFile;
  final _audioPlayer = AudioPlayer();
  bool isPlayingSound = false;
  Duration durationSound = Duration.zero;
  Duration position = Duration.zero;

  List<String> _availableLabels = [];

  @override
  void initState() {
    // TODO: implement initState
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
    loadData();
    super.initState();
  }

  final NoteService _noteService = NoteService();
  String _label = '';
  void _selectLabel(String label) {
    setState(() {
      _label = label;
    });
  }

  Future<void> loadData() async {
    try {
      List<Label> listLabel = await _noteService.getLabels();

      for (int i = 0; i < listLabel.length; i++) {
        setState(() {
          _availableLabels.add(listLabel[i].nameLabel?? '');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    _audioPlayer!.dispose();
    _videoController!.dispose();
    chewieController.dispose();
  }

  void clearController() {
    _descriptionController.clear();
    _titleController.clear();
  }

  void getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(img!.path);
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

  Future<String?> uploadImage() async {
    String? downloadURL = '';

    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      UploadTask uploadTask = storageRef.putFile(imageFile!);
      await uploadTask.whenComplete(() async {
        downloadURL = await storageRef.getDownloadURL();
      });
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
    }
    return downloadURL;
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
   
    _availableLabels = selectedLabels;
  }

  void handleAddNote() async {
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
    List<String> listLabel = _availableLabels;

    String? imageURL;
    if (imageFile == null) {
      imageURL = '';
    } else {
      imageURL = await uploadImage();
    }

    String? videoURL;
    if (videoFile == null) {
      videoURL = '';
    } else {
      videoURL = await uploadVideo();
    }
    String soundURL;
    if (audioFile == null) {
      soundURL = '';
    } else {
      soundURL = await uploadSound() ?? '';
    }
    
    Note note = Note(
        title: title,
        description: description,
        label: listLabel,
        uid: uid,
        noteid: '',
        password: '',
        imageURL: imageURL,
        videoURL: videoURL,
        soundURL: soundURL,
        isDelete: false,
        dayDelete: 1,
        isPinned: false,
        timestamp: Timestamp.now());
    print('456');
    await _noteService.addNote(note);
    clearController();

    setState(() {
      _isLoading = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
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
                    'Create',
                    style: TextStyle(
                        fontSize: 33,
                        color: Colors.pinkAccent.shade400,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'New Todo',
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
                  label("Label"),
                  SizedBox(
                    height: 12,
                  ),
                  LabelSelector(
                      allLabels: _availableLabels,
                      onLabelsSelected: onLabelsSelected),
                  SizedBox(
                    height: 25,
                  ),
                  label("Description"),
                  SizedBox(
                    height: 12,
                  ),
                  description(),
                  SizedBox(
                    height: 12,
                  ),
                  label('Image'),
                  SizedBox(
                    height: 12,
                  ),
                  imageFile == null
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
                  _videoController == null
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
                    height: 40,
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

  Widget submitAdd() {
    return InkWell(
      onTap: () {
        handleAddNote();
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
                  "Add Todo",
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
            color: Colors.black,
            fontSize: 17,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Task Title",
              hintStyle: TextStyle(
                color: Colors.black,
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

  Widget _buildAudio() {
    return _audioURL == null ? _buildFilePicker() : _buildAudioPlayer();
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
                        print('test play aduio');
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
            color: Colors.black,
            fontSize: 17,
          ),
          maxLines: null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Task Title",
              hintStyle: TextStyle(
                color: Colors.black,
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
