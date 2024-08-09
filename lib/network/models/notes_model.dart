

class NoteModel {
  String title;
  DateTime time;
  bool bookmarked;
  int noteLength;
  int titleLength;
  String note;

  NoteModel({
    required this.title,
    required this.note,
    required this.bookmarked,

}) : time = DateTime.now(), titleLength = title.trim().length, noteLength = note.trim().length;

}