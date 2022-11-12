import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/main.dart';
import 'package:noted/models/note.dart';

Future<void> colorDialog(BuildContext context, WidgetRef ref, Note note) async {
  // create some values

  // Color pickerColor = const Color(0xff443a49);
  // Color currentColor = const Color(0xff443a49);

// // ValueChanged<Color> callback
// void changeColor(Color color) {
//   setState(() => pickerColor = color);
// }

// raise the [showDialog] widget
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: Colors.white,
          onColorChanged: (newColor) =>
              ref.read(newColorStateProvider.notifier).state = newColor,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Transparent'),
          onPressed: () async {
            await ref
                .watch(notesChangeNotifierProvider)
                .updateColor(
                  note,
                  Colors.transparent,
                )
                .then((value) => Navigator.of(context).pop());
          },
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            await ref
                .watch(notesChangeNotifierProvider)
                .updateColor(
                  note,
                  ref.watch(newColorStateProvider),
                )
                .then((value) => Navigator.of(context).pop());
          },
        ),
      ],
    ),
  );
}
