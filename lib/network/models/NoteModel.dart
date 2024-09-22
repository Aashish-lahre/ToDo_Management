import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:task_management/common/utility/generate_note_id.dart';

part 'NoteModel.g.dart';

DateTime nowWithoutMilliseconds() {
  DateTime now = DateTime.now();
  // Create a new DateTime without milliseconds
  DateTime timeWithoutMilliseconds = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
  );
  return timeWithoutMilliseconds;
}

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
  @HiveField(6)
  String id;

  NoteModel({
    required this.title,
    required this.note,
    required this.bookmarked,
    DateTime? time,
    String? id,
}) : id = id ?? generateRandomString(16), time = time ?? nowWithoutMilliseconds(), titleLength = title.trim().length, noteLength = note.trim().length;


  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] ?? generateRandomString(16),
      title: map['title'] ?? '',
      bookmarked: map['bookmarked'] ?? false,
      time: map['time'] is DateTime
          ? map['time']
          : DateTime.tryParse(map['time'].toString()) ?? nowWithoutMilliseconds(),
      note: map['note'] ?? '',

    );
  }


}

// To auto generate typeAdapter, run this code in terminal = dart run build_runner build