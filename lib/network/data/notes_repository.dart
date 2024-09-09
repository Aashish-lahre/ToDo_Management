import 'package:hive/hive.dart';
import 'package:task_management/network/models/NoteModel.dart';

class NotesRepository {
  final String boxName = "NoteModelBox";

  Future<Box<NoteModel>> openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    } else {
      return await Hive.openBox<NoteModel>(boxName);
    }
  }

  Future<List<NoteModel>> getNotes() async {
    Box<NoteModel> box = await openBox();
    return box.values.toList();
  }

  // Future<Box<NoteModel>> getNotes() async {
  //   Box<NoteModel> box = await openBox();
  //   for(int i in box.keys.toList()) {
  //     print('fetching = key : $i --> title : ${box.get(i)?.title}');
  //     // print('keys : $i');
  //   }
  //   return box;
  // }

  Future<void> editNote(int index, NoteModel newNote) async {
    Box<NoteModel> box = await openBox();

    // box.putAt(index, newNote);
    box.deleteAt(index);
    box.add(newNote);

    // for (int i in box.keys.toList()) {}
  }

  Future<void> addNote(NoteModel newNote) async {
    Box<NoteModel> box = await openBox();
    box.add(newNote);
  }

  Future<void> deleteNote(int index) async {
    Box<NoteModel> box = await openBox();

    box.deleteAt(index);

    for (int i in box.keys.toList()) {}
  }
}
