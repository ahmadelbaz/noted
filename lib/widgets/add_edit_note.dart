import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noted/models/note.dart';

final titleController = TextEditingController();
final bodyController = TextEditingController();

Future<Note?> addOrUpdateDialog(BuildContext context, [Note? existingNote]) {
  log('Exis note id : ${existingNote?.uuid}');
  String? title = existingNote?.title;
  String? body = existingNote?.body;
  bool? isFavorite = existingNote?.isFavorite ?? false;

  titleController.text = title ?? '';
  bodyController.text = body ?? '';

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add a note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Enter title here...',
              ),
              onChanged: (value) => title = value,
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Enter body here...',
              ),
              onChanged: (value) => body = value,
            ),
            IconButton(
              onPressed: () {
                isFavorite = !isFavorite!;
              },
              icon: Icon(isFavorite! ? Icons.favorite : Icons.favorite_border),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (title != null && body != null) {
                if (existingNote != null) {
                  // We update the existing person
                  final updatedPerson = existingNote.updated(
                    title,
                    body,
                  );
                  Navigator.of(context).pop(updatedPerson);
                } else {
                  // No existing person, so we create a new one
                  final newNote =
                      Note(title: title!, body: body!, isFavorite: isFavorite!);
                  Navigator.of(context).pop(newNote);
                }
              } else {
                // No name or age
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
