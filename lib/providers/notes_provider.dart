import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noted/models/note.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  int get count => _notes.length;

  UnmodifiableListView get notes => UnmodifiableListView(_notes);

  // Variable to detect current note we are working on right now
  Note _currentNote = Note(title: '', body: '', isFavorite: false);
  Note get currentNote => _currentNote;

  setCurrentNote(Note note) {
    _currentNote = note;
    notifyListeners();
  }

  // Method to add new note
  void add(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  // Method to remove a note
  void remove(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  // Method to update title
  Future<void> updateTitle(Note note, String newTitle) async {
    final index = _notes.indexOf(note);
    Note selectedNote = _notes[index];
    log('this is title we want to edit : ${selectedNote.title}');
    _notes[index] = selectedNote.updated(
      newTitle,
      note.body,
      note.isFavorite,
    );
    _currentNote = _notes[index];
    notifyListeners();
    log('this is title we want to edit : ${selectedNote.title}');
  }

  // Method to update body
  Future<void> updateBody(Note note, String newBody) async {
    final index = _notes.indexOf(note);
    Note selectedNote = _notes[index];
    _notes[index] = selectedNote.updated(
      note.title,
      newBody,
      note.isFavorite,
    );
    _currentNote = _notes[index];
    notifyListeners();
  }

  // void update(Note updatedNote) {
  //   final index = _notes.indexOf(updatedNote);
  //   Note oldNote = _notes[index];
  //   if (oldNote.title != updatedNote.title ||
  //       oldNote.body != updatedNote.body) {
  //     _notes[index] = oldNote.updated(
  //       updatedNote.title,
  //       updatedNote.body,
  //       updatedNote.isFavorite,
  //     );
  //     notifyListeners();
  //   }
  // }

  // Method to switch between favorite or not
  void switchFavorite(Note note) {
    final index = _notes.indexOf(note);
    Note oldNote = _notes[index];
    _notes[index] = oldNote.updated(
      note.title,
      note.body,
      !note.isFavorite,
    );
    _currentNote = _notes[index];
    notifyListeners();
  }

  // Method to get isFavorite value for specific note
  bool getFavorite(Note note) {
    final index = _notes.indexOf(note);
    Note sNote = _notes[index];
    // notifyListeners();
    return sNote.isFavorite;
  }
}
