class Note {
  final String title;
  final String description;
  final String category;
  final String uid;
  final int noteid;
  final String? password;

  Note({
    required this.title,
    required this.description,
    required this.category,
    required this.uid,
    required this.noteid,
     this.password
  });
}