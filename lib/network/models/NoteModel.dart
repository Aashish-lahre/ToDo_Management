import 'package:hive/hive.dart';

part 'NoteModel.g.dart';

@HiveType(typeId: 1)
class NoteModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime time;
  @HiveField(2)
  bool bookmarked;
  @HiveField(3)
  int noteLength;
  @HiveField(4)
  int titleLength;
  @HiveField(5)
  String note;

  NoteModel({
    required this.title,
    required this.note,
    required this.bookmarked,

}) : time = DateTime.now(), titleLength = title.trim().length, noteLength = note.trim().length;

}