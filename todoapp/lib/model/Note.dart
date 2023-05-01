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
  Note(
      {required this.title,
      required this.description,
      required this.category,
      required this.uid,
      required this.noteid,
      this.timestamp,
      this.password,
      this.imageURL});

  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      noteid: data['noteid'],
      title: data['title'],
      description: data['content'],
      password: data['password'],
      category:  data['category'],
      uid: data['uid'],
      timestamp: data['timestamp']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'noteid': noteid,
      'title': title,
      'description': description,
      'password': password,
    };
  }
}
