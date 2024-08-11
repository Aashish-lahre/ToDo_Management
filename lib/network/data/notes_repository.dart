import 'package:hive/hive.dart';
import 'package:task_management/network/models/NoteModel.dart';

class NotesRepository {
  final String boxName = "NoteModelBox";

  Future<Box<NoteModel>> openBox() async {
    if(Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    } else {
      return await Hive.openBox<NoteModel>(boxName);
    }
  }

  Future<List<NoteModel>> getNotes() async {
    Box<NoteModel> box = await openBox();
    return box.values.toList();
  }

  Future<void> addNote(NoteModel newNote) async {
    Box<NoteModel> box = await openBox();
    box.add(newNote);
  }

  Future<void> deleteNote(int index) async {
    Box<NoteModel> box = await openBox();
    box.deleteAt(index);
  }

  Future<void> editNote(int index, NoteModel newNote) async {
    Box<NoteModel> box = await openBox();
    box.putAt(index, newNote);
  }
}