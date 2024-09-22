import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/utility/firebase_utility.dart';
import 'package:task_management/network/data/header_message_provider.dart';
import 'package:task_management/network/data/sync_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';

import 'notes_repository.dart';

class NotesProvider with ChangeNotifier {
  final NotesRepository _repository = NotesRepository();
  List<NoteModel> _notes = [];
  List<NoteModel> _fetchedNotes = [];
  List<NoteModel> _exclusiveFetchedNotes =
      []; // notes that only fetched notes have local notes does not have
  List<NoteModel> _exclusiveLocalNotes =
      []; // notes that only local notes have fetched notes does not have
   bool isSynced = false;
  bool? _localAndFetchedNotesAreSynced = null;
  String? _headerErrorMessage = null;
  bool notesAreReversed = true;
  Map<String, dynamic> _userDetails ={};



  // Future<void> _initialize() async {
  //   await _initialiseData();
  // }

  List<NoteModel> get notes {
    return _notes;
  }

  Map<String, dynamic> get userDetails {
    return _userDetails;
  }

  List<NoteModel> get exclusiveFetchedNotes {
    return [..._exclusiveFetchedNotes];
  }

  List<NoteModel> get exclusiveLocalNotes {
    return [..._exclusiveLocalNotes];
  }

  (List<NoteModel>, List<NoteModel>) get getBothExclusiveNotes {
    return (exclusiveLocalNotes, exclusiveFetchedNotes);
  }

  bool? get localAndFetchedNotesAreSynced {
    return _localAndFetchedNotesAreSynced;
  }

  String? get headerErrorMessage {
    return _headerErrorMessage;
  }

  Future<bool> initialiseData() async {
    try {
      // Fetch data from repository

        var map = await _repository.getData();

      // Safely cast notes to List<NoteModel> if it exists and is of the correct type
      var notes = map['notes'];
      print('notes : $notes');
      if (notes is List) {
        _notes = notes.map((note) => note as NoteModel).toList();
        if (notesAreReversed) {
          print('notes are reversed');
          _notes = _notes.reversed.toList();
        }
      } else {
        _notes = []; // Initialize as empty list if no notes are found
      }
      print('about to call notify listeners');
      // notifyListeners();
      print('after notify listeners');
      var (isUserNotesSynced, getUserDetails) = checkIfUserAndSynced(map);
      print('is synced : $isSynced');
      isSynced = isUserNotesSynced;
      _userDetails = getUserDetails;
      print('initialized has run and user details is available : $_userDetails');
      notifyListeners();

      if (isUserNotesSynced) {
        // Start fetching _fetchedNotes in the background
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors that might occur during fetching
      print('Error fetching data: $e');
      throw Exception("error in initialisation : $e");
    }
  }

  Map<String, dynamic> getUserDetails(Map<dynamic, dynamic> details) {
    Map<String, dynamic> typedUserDetails =
    Map<String, dynamic>.from(details);

    // Ensure all expected fields are present and handle null values
    Map<String, dynamic> userDetails = {
      'name': typedUserDetails['name']!,
      'email': typedUserDetails['email']!,
      'password': typedUserDetails['password']!,
      'isSynced': typedUserDetails['isSynced']!,
    };
    return userDetails;
  }

  (bool isSynced, Map<String, dynamic> userDetails) checkIfUserAndSynced(Map<String, Object> map) {
    var type = map['type'];
    if (type == null) {
      throw Exception("type of UserNotesBox is null");
    }
    if (type.toString() == 'user') {
      var rawUserDetails = map['userDetails'];
      if (rawUserDetails is Map) {
        var userDetails = getUserDetails(rawUserDetails);

        if (userDetails['isSynced'] == true) {
          return (true, userDetails);
        }
        return (false, userDetails);
      } else {
        throw Exception("userDetails is not a valid Map<String, dynamic>");
      }
    }
    return (false, {});
  }

  List<NoteModel> getNoteModelsFromListOfMap(List rawNotes) {
    print('rawNotes : $rawNotes');
    print('rawNotes type : ${rawNotes.runtimeType}');
    return rawNotes
        .map((noteData) => NoteModel.fromMap(noteData as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> getMapFromNoteModel(NoteModel note) {

    return {"id": note.id, "title": note.title, 'note': note.note, 'time': note.time.toString(), 'bookmarked': note.bookmarked};
  }

  // List<NoteModel> get getExclusiveLocalNotes {
  //
  //   return _notes.where((note) {
  //
  //     print('notes --> fetched notes');
  //     print('note --> ${note.id}');
  //     for(NoteModel fetchedNote in _fetchedNotes) {
  //       print('fetched note : ${fetchedNote.id}');
  //     }
  //     print("-------END--------");
  //     return _fetchedNotes.any((fetchedNote) => !(fetchedNote.id == note.id));
  //
  //   }).toList();
  // }

  List<NoteModel> get getExclusiveLocalNotes {
    // Create a set of ids from _fetchedNotes for value-based comparison
    Set<String> fetchedNoteIds = _fetchedNotes.map((fetchedNote) => fetchedNote.id).toSet();
    print('in get Exclusive local notes-------------------------');
print('local notes : $notes');
print('fetched notes : $_fetchedNotes');
    // Return notes whose ids are not present in fetchedNoteIds
    return _notes.where((note) => !fetchedNoteIds.contains(note.id)).toList();
  }


  // List<NoteModel> get getExclusiveFetchedNote {
  //   return _fetchedNotes.where((fetchedNote) {
  //
  //
  //     print('fetched notes --> local notes');
  //     print('fetched note --> ${getMapFromNoteModel(fetchedNote)}');
  //     for(NoteModel note in _notes) {
  //       print(' note : ${getMapFromNoteModel(note)}');
  //     }
  //     print("-------END--------");
  //     return notes.any((note) => !(note.id == fetchedNote.id));
  //
  //   }).toList();
  // }

  List<NoteModel> get getExclusiveFetchedNote {
    // Create a set of ids from _notes for value-based comparison
    Set<String> noteIds = _notes.map((note) => note.id).toSet();
    print('in get Exclusive fetched notes-------------------------');
    print('local notes : $notes');
    print('fetched notes : $_fetchedNotes');
    // Return fetchedNotes whose ids are not present in noteIds
    return _fetchedNotes.where((fetchedNote) => !noteIds.contains(fetchedNote.id)).toList();
  }



  Future<void> fetchRemoteNotes(BuildContext context) async {
    print('entered fetch remote notes');
    try {
      late User user;
      if(FirebaseAuth.instance.currentUser == null) {
        var userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _userDetails['email'],
            password: _userDetails['password']);
        user = userCredentials.user!;
      } else {
        user = FirebaseAuth.instance.currentUser!;
      }


      var documentSnapshot = await FirebaseFirestore.instance
          .collection('userNotes')
          .doc(user.email)
          .get();

      print('sign in and fetching note from firestore is successful');

      var fetchedNotes = documentSnapshot.data()!['notes'] as List;

      _fetchedNotes = getNoteModelsFromListOfMap(fetchedNotes);

      evaluateExclusiveNotes(context);




      notifyListeners();
    } on FirebaseAuthException catch (e) {
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError(e.message ?? 'Could not log In, error code : ${e.code}');
    } on FirebaseException catch (e) {
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError(e.message ?? 'user do not exists, error code : ${e.code}');
    } on SocketException catch (_) {
      print('socket exception in fetch remote note');
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError('Check your Internet connection.');
    } on TimeoutException catch (_) {
      context.read<HeaderMessageProvider>().buildHeaderMessageFromError('TimeOut, Restart the App');
    }  on HttpException catch (e) {
      print('Couldn\'t find the post 😱');
      } catch (e) {
      // throw Exception('unexpected error when fetching remote notes : $e');
      print('error on internet');
    }

    notifyListeners();
  }

  Future<void> addExclusiveFetchedNotesToHive() async {
    if(exclusiveFetchedNotes.isNotEmpty) {
      await _addAllNoteWithoutSubmittingToFirebase(exclusiveFetchedNotes);
    }
  }

  Future<Map<String, Object>> fetchUserNotes() async {

    try {
      print('fetch user notes gets called');
      Map<String, Object> userNotes = await _repository.getUserNotes();
      if(userNotes['type'] == 'user') {
        _userDetails = getUserDetails(userNotes['userDetails'] as Map<dynamic, dynamic>);
      }
      print('userDetails in fetchUserNotes : $_userDetails');
      try {
        _notes = List<NoteModel>.from(userNotes['notes'] as List<dynamic>);

      } catch(e) {
        throw Exception('error caught : $e');
      }
      print('_notes from fetchUserNotes : $_notes');
      _exclusiveLocalNotes = getExclusiveLocalNotes;
      if (notesAreReversed) {
        _notes = _notes.reversed.toList();
      }
      for(var note in _notes) {
        print('note time : ${note.time}');
      }
      notifyListeners();
      return userNotes;
    } catch(e) {
      print('error');
      print(e);
      print('fetch user notes gets called');
      Map<String, Object> userNotes = await _repository.getUserNotes();
      if(userNotes['type'] == 'user') {
        _userDetails = getUserDetails(userNotes['userDetails'] as Map<dynamic, dynamic>);
      }
      print('userDetails in fetchUserNotes : $_userDetails');
      try {
        _notes = List<NoteModel>.from(userNotes['notes'] as List<dynamic>);

      } catch(e) {
        throw Exception('error caught : $e');
      }
      print('_notes from fetchUserNotes : $_notes');
      _exclusiveLocalNotes = getExclusiveLocalNotes;
      if (notesAreReversed) {
        _notes = _notes.reversed.toList();
      }
      for(var note in _notes) {
        print('note time : ${note.time}');
      }
      notifyListeners();
      return userNotes;
    }

  }


  Future<void> updateUser({required Map<String, dynamic> details, required bool keepNotes}) async {
    await _repository.updateUser(details, keepNotes);
    await fetchUserNotes();
  }



  Future<void> toggleSync() async {
    bool newSync = await _repository.toggleSync();
    print('new Sync : $newSync');
    isSynced = newSync;
    fetchUserNotes();
  }

  int getForwardIndexIfNotesReversed(int index) {
    if (notesAreReversed) {
      return notesLength - 1 - index;
    }
    return index;
  }

  int get notesLength {
    return _notes.length;
  }

  Future<void> _addAllNoteWithoutSubmittingToFirebase(List<NoteModel> notes) async {
    for(NoteModel note in notes) {
      await _repository.addNote(note);
    }
    await fetchUserNotes();
  }

  Future<void> addNote(NoteModel newNote, BuildContext context) async {
    await _repository.addNote(newNote);
    await fetchUserNotes();
    if(isSynced) {
      try {
        await FirebaseUtility.submitNoteToFirebase(null, newNote, _userDetails, context);
        _fetchedNotes.add(newNote);
        evaluateExclusiveNotes(context);
      } on SocketException catch(e) {
        print('socket exception');
      } catch(e) {
        print(e);
      }



    }




  }

  Future<int> addNoteReturnIndex(NoteModel newNote, BuildContext context) async {
    await addNote(newNote, context);
    return _notes.indexOf(newNote);
  }

  Future<void> deleteNote(int index, BuildContext context) async {
    // todo if type == user and isSynced == true --> delete from firestore too if available, it might not be available if its not synced properly
    NoteModel note = _notes.elementAt(index);
    var mapToRemove = getMapFromNoteModel(note);
    index = getForwardIndexIfNotesReversed(index);
    await _repository.deleteNote(index);

    if(isSynced) {
      print('is synced : $isSynced');
      String userEmail = _userDetails['email'];
      print('userEmail: $userEmail');
      FirebaseUtility.deleteMapFromFireStoreIfExists(userEmail, mapToRemove, context);
      _fetchedNotes.remove(note);
    }

    await fetchUserNotes();
    // notifyListeners();
  }

  void evaluateExclusiveNotes(BuildContext context) {
    _exclusiveLocalNotes = getExclusiveLocalNotes;
    _exclusiveFetchedNotes = getExclusiveFetchedNote;
    _localAndFetchedNotesAreSynced =
        _exclusiveLocalNotes.isEmpty && _exclusiveFetchedNotes.isEmpty;

    if(_localAndFetchedNotesAreSynced!) {
      context.read<SyncProvider>().updateSyncStatus(SyncStatus.synced);
    } else {
      print('evaluate exclusive notes are not equal');
      context.read<SyncProvider>().updateSyncStatus(SyncStatus.notSynced);
      context.read<HeaderMessageProvider>().buildHeaderMessageFromExclusiveList(exclusiveLocalNotes, exclusiveFetchedNotes, context);
    }
  }

  Future<void> editNote(NoteModel previousNote, NoteModel newNote, BuildContext context) async {
    // keep the old version
    // add the new version of this note and show the new version
    int index = _notes.indexOf(previousNote);
    if (index != -1) {
      index = getForwardIndexIfNotesReversed(index);
      await _repository.editNote(index, newNote);

        if(isSynced) {
          await FirebaseUtility.submitNoteToFirebase(previousNote, newNote, _userDetails, context);
          _fetchedNotes.remove(previousNote);
          _fetchedNotes.add(newNote);

          evaluateExclusiveNotes(context);

        }


      await fetchUserNotes();
    }
    // notifyListeners();
  }

  Future<void> editBookmark(NoteModel note, bool newBookmarkStatus) async {
    // Find the index of the note in the list
    int index = _notes.indexOf(note);

    if (index != -1) {
      index = getForwardIndexIfNotesReversed(index);
      // Flip the bool in the bookmark property
      // _notes[index].bookmarked = newBookmarkStatus;
      NoteModel newNote = note;
      newNote.bookmarked = newBookmarkStatus;
      await _repository.editNote(index, newNote);
      await fetchUserNotes();
    }
    // print('note bookmark : ${_notes[index].bookmarked}');
    // notifyListeners();
  }
}
