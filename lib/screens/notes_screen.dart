import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/main.dart';
import 'package:noted/models/note.dart';
import 'package:noted/screens/add_edit_note_screen.dart';

// Provider (State) to detect which note we are using right now
// final currentNoteStateProvider = StateProvider<Note>(
//   (ref) => Note(title: 'SS', body: 'DD', isFavorite: true),
// );

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final notesProvider = ref.watch(notesChangeNotifierProvider);
          return ListView.builder(
            itemCount: notesProvider.count,
            itemBuilder: ((context, index) {
              final note = notesProvider.notes[index];
              return ListTile(
                title: Text(
                  note.title,
                ),
                subtitle: Text(note.body),
                trailing: IconButton(
                  onPressed: () {
                    // isFavorite = !isFavorite!;
                    notesProvider.switchFavorite(note);
                  },
                  icon: Icon(
                    notesProvider.getFavorite(note)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
                onTap: () async {
                  notesProvider.setCurrentNote(note);
                  // final updatedNote =
                  // await addOrUpdateDialog(context, notesProvider, note);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddEditNoteScreen(),
                    ),
                  );
                },
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final newNote = await addOrUpdateDialog(
          //     context, ref.watch(notesChangeNotifierProvider));
          // if (newNote != null) {
          // }
          final newNote = Note(title: '', body: '', isFavorite: false);
          final notesProvider = ref.read(notesChangeNotifierProvider);
          notesProvider.add(newNote);
          notesProvider.setCurrentNote(newNote);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add), // TODO : Check the note with good FAB
      ),
    );
  }
}
