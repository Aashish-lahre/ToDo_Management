import 'package:hive/hive.dart';
import 'package:task_management/network/models/NoteModel.dart';

class NotesRepository {
  final String boxName = "NoteModelBox";
  final Map<String, Object> boxData = {
    'type': 'guest',
    'userDetails' : {},
    'notes': [],
  };

  // Future<Box<NoteModel>> openBox() async {
  //   if (Hive.isBoxOpen(boxName)) {
  //     return Hive.box(boxName);
  //   } else {
  //     return await Hive.openBox<NoteModel>(boxName);
  //   }
  // }

  Future<Box<Map<dynamic, dynamic>>> openBox() async {
    try {
      if (await Hive.boxExists(boxName)) {
        print('note box exists');
        if (Hive.isBoxOpen(boxName)) {
          print('box was open');
          return Hive.box(boxName);
        } else {
          print('box was not open');
          try {
            var box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);


            // Safely retrieve and cast the data from the box
            try {
            var data = box.getAt(0);


            } catch (e) {
              print('error made successfully');
            }
            // if (rawData is Map) {
            //   try {
            //     Map<String, Object> data = Map<String, Object>.from(rawData as Map<String, Object>);
            //
            //   } catch (e) {
            //     print('error made successfully');
            //   }
            //   // print('Data: $data');
            // } else {
            //   print('Data not found or is not a Map');
            // }

            return box;
          } catch (e) {
            print('got the error');
            throw Exception(e);
          }
        }
      } else {
        print('box does not exists, creating one...');
        Box<Map<dynamic, dynamic>> box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
        if (box.isEmpty) {
          try {
            await box.put('data', boxData); // Put data only if the box is empty
          } catch (e) {
            print("can't access index 0");
          }

          print('box created');
          print(box.getAt(0));

        }
        return box;
      }
    } catch (e) {
      // Handle errors here
      throw Exception('Failed to open or create the box: $e');
    }
  }




  // Future<List<NoteModel>> getNotes() async {
  //   Box<NoteModel> box = await openBox();
  //   return box.values.toList();
  // }

  Future<String> getType() async {
    Box<Map<dynamic, dynamic>> box = await openBox();
    // Map<String, Object> map = {'type': (box.getAt(0)!['type']! as String), 'notes': (box.getAt(0)!['notes']! as List<NoteModel>)};


    return box.get('type') as String;
  }

  Future<void> updateUser(Map<String, dynamic> details, bool keepNotes) async {
    Box<Map<dynamic, dynamic>> box = await openBox();
    // box.putAt(index, newNote);
    Map<dynamic, dynamic> userMap = box.getAt(0)!;
    String type = details['type'] as String;
    Map<dynamic, dynamic> userDetails = details['userDetails'] as Map;

    userMap['type'] = type;
    userMap['userDetails'] = userDetails;

    if(!keepNotes) {
      userMap['notes'] = [];
    }

    await box.putAt(0, userMap);


  }

  Future<bool> toggleSync() async {
    print('toggle screen called');
    Box<Map<dynamic, dynamic>> box = await openBox();
    // box.putAt(index, newNote);
    Map<dynamic, dynamic> userMap = box.getAt(0)!;
    Map<dynamic, dynamic> userDetails = userMap['userDetails'] as Map;
    userDetails['isSynced'] = !userDetails['isSynced'];
    print('new sync in repo : ${ userDetails['isSynced']}');

    userMap['userDetails'] = userDetails;
    print('new map in repo : $userMap');


    await box.putAt(0, userMap);

    return userDetails['isSynced'];


  }


  Future<Map<String, Object>> getData() async {
    Box<Map<dynamic, dynamic>> box = await openBox();


    var data = box.getAt(0);





    // Check if data exists (null handling)
    if (data == null) {
      throw Exception("No data found at index 0. data is null");
    }

    // Check if data is a valid Map<String, Object>

      print('userNotesBox data is Map');
      // Perform a safe cast to Map<String, Object>
      return Map<String, Object>.from(data);

  }







  Future<Map<String, Object>> getUserNotes() async {
    Box<Map<dynamic, dynamic>> box = await openBox();
    print("box value type in get User NOtes : ${box.getAt(0).runtimeType}");

    var userNotes = box.getAt(0)!;
      return Map<String, Object>.from(userNotes);
    }




  // Future<Box<NoteModel>> getNotes() async {
  //   Box<NoteModel> box = await openBox();
  //   for(int i in box.keys.toList()) {
  //     print('fetching = key : $i --> title : ${box.get(i)?.title}');
  //     // print('keys : $i');
  //   }
  //   return box;
  // }

  // Future<void> editNote(int index, NoteModel newNote) async {
  //   Box<NoteModel> box = await openBox();
  //
  //   // box.putAt(index, newNote);
  //   box.deleteAt(index);
  //   box.add(newNote);
  //
  //   // for (int i in box.keys.toList()) {}
  // }

  // Future<void> editNote(int index, NoteModel newNote) async {
  //   Box<Object> box = await openBox();
  //
  //   // box.putAt(index, newNote);
  //   List<NoteModel> allNotes = box.get('notes') as List<NoteModel>;
  //   allNotes.removeAt(index);
  //   box.put('notes', allNotes);
  //   // (box.getAt(0)!['notes']! as List<NoteModel>).removeAt(index);
  //   // (box.getAt(0)!['notes']! as List<NoteModel>).add(newNote);
  //
  //   // for (int i in box.keys.toList()) {}
  // }
  Future<void> editNote(int index, NoteModel newNote) async {
    Box<Map<dynamic, dynamic>> box = await openBox();

    // box.putAt(index, newNote);
    Map<dynamic, dynamic> userMap = box.getAt(0)!;
    List<NoteModel> allNotes = List<NoteModel>.from(userMap['notes'] as List<dynamic>);
    allNotes.removeAt(index);
    allNotes.add(newNote);
    userMap['notes'] = allNotes;
    await box.putAt(0, userMap);
    // (box.getAt(0)!['notes']! as List<NoteModel>).removeAt(index);
    // (box.getAt(0)!['notes']! as List<NoteModel>).add(newNote);

    // for (int i in box.keys.toList()) {}
  }

  Future<void> editType({required String newType}) async {
    Box<Map<dynamic, dynamic>> box = await openBox();

    // box.putAt(index, newNote);
    Map<dynamic, dynamic> userMap = box.getAt(0)!;
    userMap['type'] = newType;

    await box.putAt(0, userMap);

    // for (int i in box.keys.toList()) {}
  }



  // Future<void> addNote(NoteModel newNote) async {
  //   Box<NoteModel> box = await openBox();
  //   box.add(newNote);
  // }
  //
  // Future<void> deleteNote(int index) async {
  //   Box<NoteModel> box = await openBox();
  //
  //   box.deleteAt(index);
  //
  //   for (int i in box.keys.toList()) {}
  // }

  // Future<void> addNote(NoteModel newNote) async {
  //   Box<Object> box = await openBox();
  //   bool exists = await Hive.boxExists(boxName);
  //   print('is note box empty : $exists');
  //   print('iteration from add note');
  //   for(var key in box.keys) {
  //     print('keys are : $key --> ${box.get(key)}');
  //   }
  //   print('adding note process start...');
  //   if(box.containsKey('type')) {
  //     print('contains key');
  //   } else {
  //     print('does not contains key');
  //   }
  //   var allNotes = box.get('notes');
  //   if((allNotes as List<Object>).isEmpty) {
  //     print('all notes is empty');
  //   }
  //   // else if((allNotes)) {
  //   //   print('all notes is empty');
  //   // }
  //
  //   print('fetched notes');
  //   allNotes.add(newNote);
  //   print('added newNote');
  //   box.put('notes', allNotes);
  //   print('notes been updated');
  //   for(var key in box.keys) {
  //     print('keys are : $key --> ${box.get(key)}');
  //   }
  // }

  Future<void> addNote(NoteModel newNote) async {
    Box<Map<dynamic, dynamic>> box = await openBox();

    Map<dynamic, dynamic> userMap = box.getAt(0)!;
    List<dynamic> allNotes = (userMap['notes'] as List)..add(newNote);
    userMap['notes'] = allNotes;
    await box.putAt(0, userMap);
    // for(var key in box.keys) {
    //   print('keys are : $key --> ${box.get(key)}');
    // }
  }

  // Future<void> createBoxFirstEntry(String type) async {
  //   Box<Object> box = await openBox();
  //   box.put('type', type);
  //   box.put('notes', <NoteModel>[]);
  //   print('successfully create box first entry');
  //   for(var key in box.keys) {
  //     print('keys are : $key --> ${box.get(key)}');
  //   }
  // }

  // Future<void> deleteNote(int index) async {
  //   Box<Object> box = await openBox();
  //
  //   List<NoteModel> allNotes = box.get('notes') as List<NoteModel>;
  //   allNotes.removeAt(index);
  //   box.put('notes', allNotes);
  //
  //   // for (int i in box.keys.toList()) {}
  // }

  Future<void> deleteNote(int index) async {
    Box<Map<dynamic, dynamic>> box = await openBox();

    Map<dynamic, dynamic> userMap = box.getAt(0)!;
    List<dynamic> allNotes = (userMap['notes'] as List)..removeAt(index);
    userMap['notes'] = allNotes;
    await box.putAt(0, userMap);

    // for (int i in box.keys.toList()) {}
  }


  Future<void> deleteAllNote() async {
    print('all notes is about to be deleted');
    Box<Map<dynamic, dynamic>> box = await openBox();

    box.clear();


  }
}
