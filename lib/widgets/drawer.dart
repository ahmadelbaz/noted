import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/functions/share.dart';
import 'package:noted/main.dart';
import 'package:noted/widgets/custom_listtile.dart';

class DrawerView extends ConsumerWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Call providers we need to use
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    final isDarkProvider = ref.watch(isDarkStateProvider);
    // Add color to background and appbar depends on dark mode or light mode
    final backGorundColor =
        isDarkProvider ? const Color(0xff006666) : Colors.teal;
    return Drawer(
      backgroundColor: backGorundColor,
      child: ListView(
        children: [
          AppBar(
            title: const Text('Noted'),
            backgroundColor: backGorundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () async {
                  ref.read(isDarkStateProvider.notifier).state =
                      !ref.read(isDarkStateProvider.notifier).state;
                  await notesProvider.saveTheme(ref.watch(isDarkStateProvider));
                },
                icon: Icon(
                  isDarkProvider
                      ? Icons.wb_sunny_rounded
                      : Icons.dark_mode_rounded,
                ),
              ),
            ],
          ),
          customListTile(() => shareAllNotes(context, notesProvider.getAll()),
              'Share All Notes', Icons.share_rounded),
          // We will use this divider when we add categories to separate sections
          // Divider(
          //   thickness: deviceHeight * 0.002,
          //   // color: Colors.deepOrange,
          //   indent: deviceWidth * 0.1,
          //   endIndent: deviceWidth * 0.1,
          // ),
          customListTile(() {}, 'Trash', Icons.delete_rounded),
          customListTile(() {}, 'Settings', Icons.settings_rounded),
          customListTile(() {}, 'About us', Icons.person_rounded),
        ],
      ),
    );
  }
}
