import 'package:flutter/material.dart';
import 'package:task_management/network/models/notes_model.dart';

class NotesProvider with ChangeNotifier {
  final List<NoteModel> _notes = [];

  List<NoteModel> get notes {
    return _notes;
  }

  int get notes_length {
    return _notes.length;
  }

  void addNote(NoteModel newNote) {
    print('new note added');
    _notes.add(newNote);
    print('notes length : ${notes.length}');
    notifyListeners();
  }

  int addNoteReturnlength(NoteModel newNote) {
    _notes.add(newNote);
    notifyListeners();
    return _notes.length;
  }

  void deleteNote(NoteModel note) {
    _notes.remove(note);
    notifyListeners();
  }

  void editNote(NoteModel note) {
    // keep the old version
    // add the new version of this note and show the new version
    int index = _notes.indexOf(note);
    if (index != -1) {

      _notes[index] = note;
    }
    notifyListeners();
  }

  void editBookmark(NoteModel note) {
    // Find the index of the note in the list
    int index = _notes.indexOf(note);
    if (index != -1) {
      // Flip the bool in the bookmark property
      _notes[index].bookmarked = !_notes[index].bookmarked;
    }
    notifyListeners();
  }


}