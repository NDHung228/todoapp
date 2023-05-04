import 'package:cloud_firestore/cloud_firestore.dart';

class Label {
  String? nameLabel;
  final String uid;
  Timestamp? timestamp;

  Label({required this.uid, this.nameLabel, this.timestamp});

  factory Label.fromMap(Map<String, dynamic> map) {
    return Label(
        nameLabel: map['nameLabel'],
        uid: map['uid'],
        timestamp: map['timestamp']);
  }
}
