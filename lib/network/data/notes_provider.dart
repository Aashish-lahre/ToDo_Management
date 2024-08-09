import 'package:flutter/material.dart';
import 'package:task_management/network/models/notes_model.dart';

class NotesProvider with ChangeNotifier {
  final List<NoteModel> _notes = [];

  List<NoteModel> get notes {
    return _notes;
  }

  void addNote(NoteModel newNote) {
    print('new note added');
    _notes.add(newNote);
    print('notes length : ${notes.length}');
    notifyListeners();
  }

  set deleteNote(NoteModel note) {
    _notes.remove(note);
    notifyListeners();
  }

  set editNote(NoteModel note) {
    // keep the old version
    // add the new version of this note and show the new version
  }


}