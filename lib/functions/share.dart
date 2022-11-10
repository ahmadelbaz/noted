import 'package:flutter/material.dart';
import 'package:noted/models/note.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareNote(BuildContext context, Note note) async {
  await Share.share('${note.title}\n${note.body}');
}

Future<void> shareAllNotes(BuildContext context, List<Note> notes) async {
  String sharedText = '';
  for (int n = 0; n < notes.length; n++) {
    sharedText += '${notes[n].title}\n${notes[n].body}\n\n';
  }
  sharedText += 'By Noted';
  await Share.share(sharedText);
}
