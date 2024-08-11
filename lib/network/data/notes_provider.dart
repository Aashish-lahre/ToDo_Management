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

  int addNoteReturnIndex(NoteModel newNote) {
    _notes.add(newNote);
    notifyListeners();
    return _notes.indexOf(newNote);
  }

  void deleteNote(int index) {

    _notes.removeAt(index);
    notifyListeners();
  }

  void editNote(NoteModel previousNote, NoteModel newNote) {
    // keep the old version
    // add the new version of this note and show the new version
    int index = _notes.indexOf(previousNote);
    if (index != -1) {

      _notes[index] = newNote;
    }
    notifyListeners();
  }

  void editBookmark(NoteModel note, bool newBookmarkStatus) {
    // Find the index of the note in the list
    int index = _notes.indexOf(note);
    print('note index- : $index');
    if (index != -1) {
      // Flip the bool in the bookmark property
      _notes[index].bookmarked = newBookmarkStatus;
    }
    print('note bookmark : ${_notes[index].bookmarked}');
    notifyListeners();
  }


}