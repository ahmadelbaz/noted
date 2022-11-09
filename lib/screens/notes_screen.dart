import 'dart:developer';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/main.dart';
import 'package:noted/models/note.dart';
import 'package:noted/screens/add_edit_note_screen.dart';
import 'package:noted/screens/all_notes_screen.dart';
import 'package:noted/widgets/drawer.dart';

TabController? tabController;

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  static Future<void> pop({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey<ContainedTabBarViewState> key = GlobalKey();
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          log('${key.currentState?.indexIsChanging}');
          key.currentState!.animateTo(0, duration: const Duration(seconds: 1));
          if (key.currentState!.indexIsChanging) {
          } else {
            pop();
          }
          return false;
        },
        child: Scaffold(
          drawer: const DrawerView(),
          // We add this so that we hide appbar when user scrolls
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                const SliverAppBar(
                  floating: true,
                  pinned: true,
                  title: Text('Noted'),
                ),
              ];
            },
            body: Consumer(
              builder: (context, ref, child) {
                // Instance of the providers we need
                final futureProvider = ref.watch(dataFutureProvider);
                return futureProvider.when(
                  skipLoadingOnReload: true,
                  data: (data) {
                    deviceWidth = MediaQuery.of(context).size.width;
                    deviceHeight = MediaQuery.of(context).size.height;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: deviceWidth * .06),
                      child: ContainedTabBarView(
                        key: key,
                        tabs: const [
                          Icon(
                            Icons.notes_rounded,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ],
                        views: [
                          AllNotesScreen(
                            isNormalMode: true,
                          ),
                          AllNotesScreen(
                            isNormalMode: false,
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) => const Center(
                    child: Text('Error 😅'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final newNote = Note(title: '', body: '', isFavorite: false);
              final notesProvider = ref.watch(notesChangeNotifierProvider);
              notesProvider.add(newNote);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEditNoteScreen(),
                ),
              );
            },
            child: const Icon(Icons.note_add_rounded),
          ),
        ),
      ),
    );
  }
}
