import 'dart:developer';

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
    final isGridProvider = ref.watch(isGridStateProvider);
    final isDarkProvider = ref.watch(isDarkStateProvider);
    log('normal mode ? $isNormalMode');
    return notesProvider.count < 1
        ? const Center(
            child: Text('Empty! Add Note'),
          )
        // We check if we are in grid view mode or not to change the view
        : isGridProvider
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                // We have 4 modes here [Normal - searchNormal - Favorite - searchFavorite]
                // And we change the item count depends on which mode we are in
                // We have to do this in the grid view, but in list view its not a problem
                itemCount: !isNormalMode!
                    ? searchProvider
                        ? notesProvider
                            .getAllSearchFavorites(searchTextProvider)
                            .length
                        : notesProvider.getAllFavorites().length
                    : searchProvider
                        ? notesProvider.getAllSearch(searchTextProvider).length
                        : notesProvider.count,
                itemBuilder: (context, index) {
                  // Same 4 modes here and we need to check to decide which notes we are dealing with
                  final note = isNormalMode!
                      ? searchProvider
                          ? notesProvider
                              .getAllSearch(searchTextProvider)[index]
                          : notesProvider.notes[index]
                      : searchProvider
                          ? notesProvider
                              .getAllSearchFavorites(searchTextProvider)[index]
                          : notesProvider.getAllFavorites()[index];
                  // First we check if we are in favorite tab or all notes tab, to decide which notes will appear
                  return searchProvider &&
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
                              decoration: BoxDecoration(
                                color: note.color,
                                // We check if we are in selection mode and this is the selected note
                                // We add special border around it
                                border: selectionProvider.keys.first &&
                                        selectionProvider.values.first == note
                                    ? Border.all(
                                        width: 3,
                                        color: Colors.teal,
                                      )
                                    : null,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    10.0,
                                  ),
                                ),
                              ),
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
                                    color: isDarkProvider
                                        ? Colors.white
                                        : Colors.black,
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
                                },
                              ),
                            ),
                          ],
                        );
                },
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
                              (!note.title.toLowerCase().contains(
                                      searchTextProvider.toLowerCase()) &&
                                  !note.body.toLowerCase().contains(
                                      searchTextProvider.toLowerCase()))
                          ? Container()
                          // Then shows notes that achive the conditions
                          : Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: note.color,
                                    // We check if we are in selection mode and this is the selected note
                                    // We add special border around it
                                    border: selectionProvider.keys.first &&
                                            selectionProvider.values.first ==
                                                note
                                        ? Border.all(
                                            width: 3,
                                            color: Colors.teal,
                                          )
                                        : null,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        10.0,
                                      ),
                                    ),
                                  ),
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
                                        color: isDarkProvider
                                            ? Colors.white
                                            : Colors.black,
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
                                          .read(inSearchModeStateProvider
                                              .notifier)
                                          .state = false;
                                      ref
                                          .read(inSelectionModeStateProvider
                                              .notifier)
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
