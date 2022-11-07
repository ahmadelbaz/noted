import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/main.dart';
import 'package:noted/widgets/add_edit_note.dart';

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
                onTap: () async {
                  log('index of 1: ${notesProvider.notes.indexOf(note)}');
                  final updatedNote = await addOrUpdateDialog(context, note);
                  log('index of 2: ${notesProvider.notes.indexOf(updatedNote)}');
                  if (updatedNote != null) {
                    notesProvider.update(updatedNote);
                  }
                },
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await addOrUpdateDialog(context);
          if (newNote != null) {
            final peopleProvider = ref.read(notesChangeNotifierProvider);
            peopleProvider.add(newNote);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
