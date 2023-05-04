import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String title;
  final String description;
  final String category;
  final String uid;
  final String noteid;
  final String? password;
  Timestamp? timestamp;
  String? imageURL;
  String? videoURL;
  bool? isDelete;
  int? dayDelete;
  Note(
      {required this.title,
      required this.description,
      required this.category,
      required this.uid,
      required this.noteid,
      this.timestamp,
      this.password,
      this.imageURL,this.videoURL,
      this.isDelete,
      this.dayDelete});

}
