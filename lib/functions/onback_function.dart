import 'package:noted/providers/notes_provider.dart';

Future<bool> onWillPop(
    NoteProvider notesProvider, String title, String body) async {
  // if (title.isEmpty && body.isEmpty) {
  //   notesProvider.switchHideCurrentNote();
  //   Future.delayed(const Duration(seconds: 2), () {
  //     notesProvider.switchHideCurrentNote();
  //     notesProvider.remove(notesProvider.currentNote);
  //   });
  // }
  return true;
}
