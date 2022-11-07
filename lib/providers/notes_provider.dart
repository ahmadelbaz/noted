import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noted/models/note.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  int get count => _notes.length;

  UnmodifiableListView get notes => UnmodifiableListView(_notes);

  void add(Note person) {
    _notes.add(person);
    notifyListeners();
  }

  void remove(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  void update(Note updatedNote) {
    final index = _notes.indexOf(updatedNote);
    log('index : $index');
    Note oldNote = _notes[index];
    if (oldNote.title != updatedNote.title ||
        oldNote.body != updatedNote.body) {
      _notes[index] = oldNote.updated(
        updatedNote.title,
        updatedNote.body,
        updatedNote.isFavorite,
      );
      notifyListeners();
    }
  }

  void switchFavorite(Note note) {
    final index = _notes.indexOf(note);
    
  }
}
