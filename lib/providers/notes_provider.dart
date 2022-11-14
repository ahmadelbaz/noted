import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/database/database.dart';
import 'package:noted/main.dart';
import 'package:noted/models/note.dart';
import 'package:noted/screens/notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  UnmodifiableListView get notes => UnmodifiableListView(_notes);

  // Method to get all notes length
  int get count => _notes.length;

  // Method to get all notes
  List<Note> getAll() {
    return _notes;
  }

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
      note.color,
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
      note.color,
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
      note.color,
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

  // Method to get all favorite notes
  List<Note> getAllFavorites() {
    return _notes.where((element) => element.isFavorite!).toList();
  }

  // Method to get all search notes
  List<Note> getAllSearch(String searchText) {
    return _notes
        .where((note) =>
            note.title!.toLowerCase().contains(searchText.toLowerCase()) ||
            note.body!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  // Method to get all favorite search notes
  List<Note> getAllSearchFavorites(String searchText) {
    return _notes
        .where((note) =>
            note.isFavorite! &&
                note.title!.toLowerCase().contains(searchText.toLowerCase()) ||
            note.body!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  // Method to update color of specific note
  // Method to update body
  Future<void> updateColor(Note note, Color newColor) async {
    await myDatabase.notesDatabase();
    final index = _notes.indexOf(note);
    Note selectedNote = _notes[index];
    _notes[index] = selectedNote.updated(
      note.title,
      note.body,
      note.isFavorite,
      newColor,
    );
    await myDatabase.update(_notes[index]);
    _currentNote = _notes[index];
    notifyListeners();
  }

  // Save theme in shared preference
  Future<void> saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isDarkKey, isDark);
  }

  // Get theme from shared preference
  Future<void> getTheme(FutureProviderRef<void> ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(isDarkKey)) {
      bool isDark = prefs.getBool(isDarkKey)!;
      ref.read(isDarkStateProvider.notifier).state = isDark;
    }
  }

  // Save view [grid or list] in shared preference
  Future<void> saveView(bool isGrid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isGridKey, isGrid);
  }

  // Get view [grid or list] from shared preference
  Future<void> getView(FutureProviderRef<void> ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(isGridKey)) {
      bool isGrid = prefs.getBool(isGridKey)!;
      ref.read(isGridStateProvider.notifier).state = isGrid;
    }
  }
}
