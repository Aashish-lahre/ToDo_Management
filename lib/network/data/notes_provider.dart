import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_management/network/models/NoteModel.dart';

import 'notes_repository.dart';

class NotesProvider with ChangeNotifier {

  final NotesRepository _repository = NotesRepository();
  List<NoteModel> _notes = [];


  NotesProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchNotes();
  }

  List<NoteModel> get notes {
    return _notes;
  }



  Future<void> fetchNotes() async {
    print('executed');
    _notes = await _repository.getNotes();
    notifyListeners();
  }

  // Future<void> fetchNotes() async {
  //   print('executed');
  //   List<NoteModel>' box = await _repository.getNotes();
  //   _notes = box.values.toList();
  //   if(box.isNotEmpty) {
  //     for(int i= 0; i < box.length; i++) {
  //       _mapNotes[i] = box.values.toList()[i];
  //     }
  //   } else{
  //     _mapNotes = {};
  //   }
  //
  //
  //   notifyListeners();
  // }



  int get notes_length {
    return _notes.length;
  }

  Future<void> addNote(NoteModel newNote) async {

    await _repository.addNote(newNote);
    await fetchNotes();
    // notifyListeners();
  }

  Future<int> addNoteReturnIndex(NoteModel newNote) async {
    await addNote(newNote);
    return _notes.indexOf(newNote);
  }

  Future<void> deleteNote(int index) async {

    // _notes.removeAt(index);
    await _repository.deleteNote(index);
    await fetchNotes();
    // notifyListeners();
  }

  Future<void> editNote(NoteModel previousNote, NoteModel newNote) async {
    // keep the old version
    // add the new version of this note and show the new version
    int index = _notes.indexOf(previousNote);
    if (index != -1) {

      // _notes[index] = newNote;
      await _repository.editNote(index, newNote);
      await fetchNotes();
    }
    // notifyListeners();
  }

  Future<void> editBookmark(NoteModel note, bool newBookmarkStatus) async {
    // Find the index of the note in the list
    int index = _notes.indexOf(note);
    print('note index : $index');
    if (index != -1) {
      // Flip the bool in the bookmark property
      // _notes[index].bookmarked = newBookmarkStatus;
      NoteModel newNote = note;
      newNote.bookmarked = newBookmarkStatus;
      await _repository.editNote(index, newNote);
      await fetchNotes();
    }
    // print('note bookmark : ${_notes[index].bookmarked}');
    // notifyListeners();
  }


}