import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/main.dart';
import 'package:noted/screens/add_edit_note_screen.dart';
import 'package:noted/screens/notes_screen.dart';

// Provider (State) to switch selection note (after long tab on note)
final inSelectionModeStateProvider = StateProvider<Map<bool, dynamic>>(
  (ref) => {false: false},
);

class AllNotesScreen extends ConsumerWidget {
  bool? isNormalMode;
  AllNotesScreen({this.isNormalMode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    final searchProvider = ref.watch(inSearchModeStateProvider);
    final searchTextProvider = ref.watch(searchTextStateProvider);
    final selectionProvider = ref.watch(inSelectionModeStateProvider);
    return notesProvider.count < 1
        ? const Center(
            child: Text('Empty! Add Note'),
          )
        : ListView.builder(
            itemCount: notesProvider.count,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              // First we check if we are in favorite tab or all notes tab, to decide which notes will appear
              return !isNormalMode! && !note.isFavorite
                  ? Container()
                  // Then we check if we are in search mode and if we are searching about some specific text
                  : searchProvider &&
                          (!note.title
                                  .toLowerCase()
                                  .contains(searchTextProvider.toLowerCase()) &&
                              !note.body
                                  .toLowerCase()
                                  .contains(searchTextProvider.toLowerCase()))
                      ? Container()
                      // Then shows notes that achive the conditions
                      : Column(
                          children: [
                            Container(
                              // We check if we are in selection mode and this is the selected note
                              // We add special border around it
                              decoration: selectionProvider.keys.first &&
                                      selectionProvider.values.first == note
                                  ? BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.teal,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          10.0,
                                        ),
                                      ),
                                    )
                                  : null,
                              margin: EdgeInsets.all(deviceWidth * 0.02),
                              padding: EdgeInsets.all(deviceWidth * 0.009),
                              // color: Colors.teal,
                              child: ListTile(
                                title: AutoDirection(
                                  text: note.title,
                                  child: Text(
                                    note.title,
                                    maxLines: 1,
                                  ),
                                ),
                                subtitle: AutoDirection(
                                  text: note.body,
                                  child: Text(
                                    note.body,
                                    maxLines: 1,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () =>
                                      notesProvider.switchFavorite(note),
                                  icon: Icon(
                                    notesProvider.getFavorite(note)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                ),
                                onTap: () async {
                                  notesProvider.setCurrentNote(note);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddEditNoteScreen(),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  ref
                                      .read(inSearchModeStateProvider.notifier)
                                      .state = false;
                                  ref
                                      .read(
                                          inSelectionModeStateProvider.notifier)
                                      .state = {true: note};
                                  // notesProvider.remove(note);
                                },
                              ),
                            ),
                            // Divider to separate between items
                            const Divider(),
                          ],
                        );
            },
          );
  }
}
