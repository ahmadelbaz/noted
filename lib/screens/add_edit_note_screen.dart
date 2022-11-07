import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/main.dart';

class AddEditNoteScreen extends ConsumerWidget {
  const AddEditNoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    // final currentNoteProvider = ref.watch(currentNoteStateProvider);
    // log('this is current note title ${currentNoteProvider.title}');
    // String? title = !isNew! ? currentNoteProvider.title : '';
    // String? body = !isNew! ? currentNoteProvider.body : '';
    // bool? isFavorite = !isNew! ? currentNoteProvider.isFavorite : false;

    // titleController.text = title;
    // bodyController.text = body;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          // log('Wrong this is current note title ${notesProvider.currentNote.title}');
          // String? title = !isNew! ? notesProvider.currentNote.title : '';
          // String? body = !isNew! ? notesProvider.currentNote.body : '';
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: notesProvider.currentNote.title,
                      decoration: const InputDecoration(
                        labelText: 'Enter title here...',
                      ),
                      onChanged: (value) async {
                        await notesProvider.updateTitle(
                            notesProvider.currentNote, value);
                      },
                    ),
                    TextFormField(
                      initialValue: notesProvider.currentNote.body,
                      decoration: const InputDecoration(
                        labelText: 'Enter body here...',
                      ),
                      onChanged: (value) async {
                        await notesProvider.updateBody(
                            notesProvider.currentNote, value);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        notesProvider.switchFavorite(notesProvider.currentNote);
                      },
                      icon: Icon(
                        notesProvider.getFavorite(notesProvider.currentNote)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
