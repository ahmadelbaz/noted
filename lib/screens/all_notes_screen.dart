import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/main.dart';
import 'package:noted/screens/add_edit_note_screen.dart';

class AllNotesScreen extends ConsumerWidget {
  bool? isNormalMode;
  AllNotesScreen({this.isNormalMode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    return notesProvider.count < 1
        ? const Center(
            child: Text('Empty! Add Note'),
          )
        : ListView.builder(
            itemCount: notesProvider.count,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return !isNormalMode! && !note.isFavorite
                  ? Container()
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(deviceWidth * 0.02),
                          padding: EdgeInsets.all(deviceWidth * 0.009),
                          child: ListTile(
                            title: Text(
                              note.title,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              note.body,
                              maxLines: 1,
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
                              notesProvider.remove(note);
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
