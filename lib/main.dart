import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/providers/notes_provider.dart';
import 'package:noted/screens/add_edit_note_screen.dart';
import 'package:noted/screens/notes_screen.dart';

// Provider (change notifier) for notes list
final notesChangeNotifierProvider =
    ChangeNotifierProvider((ref) => NoteProvider());

final dataFutureProvider = FutureProvider(
  (ref) async {
    log('Trying to get the data');
    // final selected =
    await ref.watch(notesChangeNotifierProvider).getAllNotes();
    // return selected;
  },
);

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Assign screen height and width to these global variables so we can use them in all screens
    // deviceWidth = MediaQuery.of(context).size.width;
    // deviceHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => const NotesScreen(),
        '/add_edit_note': (context) => const AddEditNoteScreen(),
      },
    );
  }
}
