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

// Provider (State) to switch search mode
final inSearchModeStateProvider = StateProvider<bool>(((ref) => false));

// Provider (State) for the text we want to search with
final searchTextStateProvider = StateProvider<String>(((ref) => ''));

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  // Method to close the app when we call it
  static Future<void> pop({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Golobal key to the tab bar to controll it more
    GlobalKey<ContainedTabBarViewState> key = GlobalKey();

    // Instance of providers we need
    var searchProvider = ref.watch(inSearchModeStateProvider);
    return DefaultTabController(
      // Length of tabs (We will change it later to be dynamic maybe to add categories)
      length: 2,
      // We add willpopscope to controll when user click back button
      child: WillPopScope(
        onWillPop: () async {
          // We try to check if user in another tab that isn't the first one
          // Its not the best way to do it, and we will try to fix it in the future
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
                SliverAppBar(
                  floating: true,
                  snap: true,
                  // pinned: true,
                  // We check if we are in search mode so we change appbar title to textfield
                  title: searchProvider
                      ? TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search',
                          ),
                          autofocus: true,
                          onChanged: (value) {
                            ref.read(searchTextStateProvider.notifier).state =
                                value;
                          },
                        )
                      : const Text('Noted'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        ref.read(inSearchModeStateProvider.notifier).state =
                            !ref.read(inSearchModeStateProvider.notifier).state;
                        log('search mode ? ${ref.watch(inSearchModeStateProvider)}');
                      },
                      icon: Icon(
                        // We check if we are in search mode to change the search icon to close
                        searchProvider
                            ? Icons.cancel_rounded
                            : Icons.search_rounded,
                      ),
                    ),
                  ],
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
                        tabBarProperties: const TabBarProperties(
                          position: TabBarPosition.bottom,
                        ),
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
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: deviceHeight * 0.04),
            child: FloatingActionButton(
              tooltip: 'Add Note',
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
      ),
    );
  }
}
