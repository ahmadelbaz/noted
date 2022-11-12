import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/functions/share.dart';
import 'package:noted/main.dart';

class DrawerView extends ConsumerWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    final isDarkProvider = ref.watch(isDarkStateProvider);
    return Drawer(
      backgroundColor: Colors.teal,
      child: ListView(
        children: [
          SizedBox(height: deviceHeight * 0.04),
          IconButton(
            onPressed: () {
              ref.read(isDarkStateProvider.notifier).state =
                  !ref.read(isDarkStateProvider.notifier).state;
            },
            icon: Icon(
              isDarkProvider ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
            ),
          ),
          SizedBox(height: deviceHeight * 0.06),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text(
              'Share All Notes',
            ),
            onTap: () => shareAllNotes(context, notesProvider.getAll()),
          ),
        ],
      ),
    );
  }
}
