import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:noted/database/database.dart';
import 'package:noted/models/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  int get count => _notes.length;

  UnmodifiableListView get notes => UnmodifiableListView(_notes);

  // Variable to detect current note we are working on right now
  Note _currentNote = Note(title: '', body: '', isFavorite: false);
  Note get currentNote => _currentNote;

  // Instance from database to use it in provider
  MyDatabase myDatabase = MyDatabase();

  // Method to set current note to the one that user are using right now
  setCurrentNote(Note note) {
    _currentNote = note;
    notifyListeners();
  }

  // Method to get all notes from database
  Future<void> getAllNotes() async {
    await myDatabase.notesDatabase();
    _notes = await myDatabase.getAll('notes') as List<Note>;
    // notifyListeners();
  }

  // Method to add new note
  Future<void> add(Note note) async {
    await myDatabase.notesDatabase();
    _notes.add(note);
    _currentNote = note;
    await myDatabase.insert(note);
    notifyListeners();
  }

  // Method to remove a note
  Future<void> remove(Note note) async {
    await myDatabase.notesDatabase();
    _notes.remove(note);
    await myDatabase.delete(note);
    notifyListeners();
  }

  // Method to update title
  Future<void> updateTitle(Note note, String newTitle) async {
    await myDatabase.notesDatabase();
    final index = _notes.indexOf(note);
    Note selectedNote = _notes[index];
    _notes[index] = selectedNote.updated(
      newTitle,
      note.body,
      note.isFavorite,
    );
    await myDatabase.update(_notes[index]);
    _currentNote = _notes[index];
    notifyListeners();
  }

  // Method to update body
  Future<void> updateBody(Note note, String newBody) async {
    await myDatabase.notesDatabase();
    final index = _notes.indexOf(note);
    Note selectedNote = _notes[index];
    _notes[index] = selectedNote.updated(
      note.title,
      newBody,
      note.isFavorite,
    );
    await myDatabase.update(_notes[index]);
    _currentNote = _notes[index];
    notifyListeners();
  }

  // Method to switch between favorite or not
  Future<void> switchFavorite(Note note) async {
    await myDatabase.notesDatabase();
    final index = _notes.indexOf(note);
    Note oldNote = _notes[index];
    _notes[index] = oldNote.updated(
      note.title,
      note.body,
      !note.isFavorite!,
    );
    await myDatabase.update(_notes[index]);
    _currentNote = _notes[index];
    notifyListeners();
  }

  // Method to get isFavorite value for specific note
  bool getFavorite(Note note) {
    final index = _notes.indexOf(note);
    Note sNote = _notes[index];
    // notifyListeners();
    return sNote.isFavorite!;
  }

  // Method to search with

}
