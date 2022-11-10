import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/functions/color_dialog.dart';
import 'package:noted/functions/formate_date_time.dart';
import 'package:noted/functions/onback_function.dart';
import 'package:noted/main.dart';

// Provider (State) to lock or unlockNotes
final isLockedStateProvider = StateProvider<bool>(((ref) => false));

// we use this node to easily tavel from textfield to another
final _descriptionFocusNode = FocusNode();

class AddEditNoteScreen extends ConsumerWidget {
  const AddEditNoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    var isLockedProvider = ref.watch(isLockedStateProvider);
    return WillPopScope(
      onWillPop: () {
        return onWillPop(notesProvider, notesProvider.currentNote.title!,
            notesProvider.currentNote.body!);
      },
      child: Scaffold(
        backgroundColor: notesProvider.currentNote.color,
        appBar: AppBar(
          title: const Text('Note'),
          actions: [
            IconButton(
              tooltip: 'Change color',
              icon: const Icon(
                Icons.color_lens_rounded,
              ),
              onPressed: () async {
                await colorDialog(context, ref, notesProvider.currentNote);
              },
            ),
            IconButton(
              tooltip: isLockedProvider ? 'Unlock' : 'Lock',
              icon: Icon(
                isLockedProvider ? Icons.lock_open_rounded : Icons.lock_rounded,
              ),
              onPressed: () {
                ref.read(isLockedStateProvider.notifier).state =
                    !isLockedProvider;
              },
            ),
          ],
        ),
        body: Consumer(
          builder: (context, ref, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.025,
                      ),
                      Padding(
                        padding: EdgeInsets.all(deviceWidth * 0.025),
                        child: AutoDirection(
                          text: notesProvider.currentNote.title!,
                          child: TextFormField(
                            initialValue: notesProvider.currentNote.title,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            // We check if the note has no title or body so turn on auto focus
                            autofocus: notesProvider.currentNote.title == '' &&
                                    notesProvider.currentNote.body == ''
                                ? true
                                : false,
                            textCapitalization: TextCapitalization.sentences,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            enabled: isLockedProvider ? false : true,
                            onChanged: (value) async {
                              await notesProvider.updateTitle(
                                notesProvider.currentNote,
                                value,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(deviceWidth * 0.025),
                        child: AutoDirection(
                          text: notesProvider.currentNote.body!,
                          child: TextFormField(
                            initialValue: notesProvider.currentNote.body,
                            decoration: InputDecoration(
                              labelText: 'Content',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(),
                              ),
                            ),
                            textInputAction: TextInputAction.newline,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _descriptionFocusNode,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            enabled: isLockedProvider ? false : true,
                            onChanged: (value) async {
                              await notesProvider.updateBody(
                                notesProvider.currentNote,
                                value,
                              );
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Toggle Favorite',
                        onPressed: () {
                          notesProvider
                              .switchFavorite(notesProvider.currentNote);
                        },
                        icon: Icon(
                          notesProvider.getFavorite(
                            notesProvider.currentNote,
                          )
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                    ],
                  ),
                ),
                notesProvider.currentNote.createdDate!.millisecondsSinceEpoch ==
                        notesProvider
                            .currentNote.updatedDate!.millisecondsSinceEpoch
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Created :'),
                            Text(
                              formatDateTime(
                                notesProvider.currentNote.createdDate!,
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text('Created :'),
                                Text(
                                  formatDateTime(
                                    notesProvider.currentNote.createdDate!,
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text('Last edit: :'),
                                Text(
                                  formatDateTime(
                                    notesProvider.currentNote.updatedDate!,
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}
