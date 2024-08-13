import 'package:hive/hive.dart';
import 'package:task_management/network/models/NoteModel.dart';

class NotesRepository {
  final String boxName = "NoteModelBox";

  Future<Box<NoteModel>> openBox() async {
    print('arrived at openBOX');
    if(Hive.isBoxOpen(boxName)) {
      print('box was open, now returning...');

      return Hive.box(boxName);
    } else {
      print('box was closed, opening the box and returning...');
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
    print('editing called');
    print('index : $index');
    print('new Note: ${newNote.title}');
    Box<NoteModel> box = await openBox();
    print('putting now...');
    print('putting at index : $index, newvalue : ${box.getAt(index)?.title}');
    print('final newvalue : ${newNote.title}');
    box.putAt(index, newNote);
    print('putting done');
    for(int i in box.keys.toList()) {
      print('after editing = key : $i --> title : ${box.get(i)?.title}');
    }
  }

  Future<void> addNote(NoteModel newNote) async {
    Box<NoteModel> box = await openBox();
    box.add(newNote);
  }

  Future<void> deleteNote(int index) async {
    print('deleting at index : $index');
    Box<NoteModel> box = await openBox();
    print('executed after box instance');
    print('deleting at index : $index, key: ${box.keyAt(index)}, value: ${box.getAt(index)?.title}');
    box.deleteAt(index);
    print('key deleted');
    for(int i in box.keys.toList()) {
      print('after deleting = key : $i --> title : ${box.get(i)?.title}');
    }

  }


}