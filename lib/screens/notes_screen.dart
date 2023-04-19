import 'package:auto_direction/auto_direction.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/functions/color_dialog.dart';
import 'package:noted/functions/share.dart';
import 'package:noted/main.dart';
import 'package:noted/models/note.dart';
import 'package:noted/screens/add_edit_note_screen.dart';
import 'package:noted/screens/all_notes_screen.dart';
import 'package:noted/widgets/drawer.dart';

// Provider (State) to switch search mode
final inSearchModeStateProvider = StateProvider<bool>(((ref) => false));

// Provider (State) for the text we want to search with
final searchTextStateProvider = StateProvider<String>(((ref) => ''));

// Provider (State) to switch the list between gridview and listview
final isGridStateProvider = StateProvider<bool>(
  (ref) => false,
);

// Golobal key to the tab bar to controll it more
GlobalKey<ContainedTabBarViewState> tabKey =
    GlobalKey<ContainedTabBarViewState>();

// Main screen of the app that has the List of notes and other widgets (drawer, appbar etc.)
class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  // Method to close the app when we call it
  static Future<void> pop({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Instance of providers we need
    final notesProvider = ref.watch(notesChangeNotifierProvider);
    final searchProvider = ref.watch(inSearchModeStateProvider);
    final selectionProvider = ref.watch(inSelectionModeStateProvider);
    final isGridProvider = ref.watch(isGridStateProvider);
    return DefaultTabController(
      // Length of tabs (We will change it later to be dynamic maybe to add categories)
      length: 2,
      // We add willpopscope to controll when user click back button
      child: WillPopScope(
        onWillPop: () async {
          // First we check if we are in selection mode
          // If yes we close it first
          if (searchProvider) {
            ref.read(inSearchModeStateProvider.notifier).state = false;
            return false;
          } else if (selectionProvider.keys.first) {
            ref.read(inSelectionModeStateProvider.notifier).state = {
              false: false
            };
            return false;
          }
          // We try to check if user in another tab that isn't the first one
          // Its not the best way to do it, and we will try to fix it in the future
          tabKey.currentState!
              .animateTo(0, duration: const Duration(seconds: 1));
          if (tabKey.currentState!.indexIsChanging) {
          } else {
            pop();
          }
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: const DrawerView(),
          // We add this so that we hide appbar when user scrolls
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  // We check if we are in selection mode so we turn the title into clsoing iconbutton
                  title: selectionProvider.keys.first
                      ? IconButton(
                          tooltip: 'Close',
                          onPressed: () {
                            ref
                                .read(inSelectionModeStateProvider.notifier)
                                .state = {false: false};
                          },
                          icon: const Icon(Icons.cancel_rounded),
                        )
                      // Then we check if we are in search mode so we change appbar title to textfield
                      : searchProvider
                          ? AutoDirection(
                              text: ref.watch(searchTextStateProvider),
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Search',
                                ),
                                autofocus: true,
                                onChanged: (value) {
                                  ref
                                      .read(searchTextStateProvider.notifier)
                                      .state = value;
                                },
                              ),
                            )
                          : const Text('Noted'),
                  // We check if we are in selection mode to change th whole actions list
                  actions: selectionProvider.keys.first
                      ? [
                          IconButton(
                            tooltip: 'Change color',
                            onPressed: () async {
                              await colorDialog(
                                  context, ref, selectionProvider.values.first);
                              ref
                                  .read(inSelectionModeStateProvider.notifier)
                                  .state = {false: false};
                            },
                            icon: const Icon(Icons.color_lens),
                          ),
                          IconButton(
                            tooltip: 'Share note',
                            onPressed: () async {
                              await shareNote(
                                  context, selectionProvider.values.first);
                              ref
                                  .read(inSelectionModeStateProvider.notifier)
                                  .state = {false: false};
                            },
                            icon: const Icon(Icons.share_rounded),
                          ),
                          IconButton(
                            tooltip: 'Delete note',
                            onPressed: () {
                              notesProvider
                                  .remove(selectionProvider.values.first);
                              ref
                                  .read(inSelectionModeStateProvider.notifier)
                                  .state = {false: false};
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ]
                      : [
                          IconButton(
                            tooltip: 'Search',
                            onPressed: () {
                              ref.read(searchTextStateProvider.notifier).state =
                                  '';
                              ref
                                      .read(inSearchModeStateProvider.notifier)
                                      .state =
                                  !ref
                                      .read(inSearchModeStateProvider.notifier)
                                      .state;
                            },
                            icon: Icon(
                              // We check if we are in search mode to change the search icon to close
                              searchProvider
                                  ? Icons.cancel_rounded
                                  : Icons.search_rounded,
                            ),
                          ),
                          IconButton(
                            tooltip: isGridProvider ? 'List View' : 'Grid View',
                            onPressed: () async {
                              ref.read(isGridStateProvider.notifier).state =
                                  !isGridProvider;
                              await notesProvider
                                  .saveView(ref.watch(isGridStateProvider));
                            },
                            icon: Icon(
                              isGridProvider
                                  ? Icons.view_list_rounded
                                  : Icons.grid_view_rounded,
                            ),
                          ),
                        ],
                ),
              ];
            },
            body: Consumer(
              builder: (context, ref, child) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: deviceWidth * .03),
                  child: ContainedTabBarView(
                    tabBarProperties: const TabBarProperties(
                      labelColor: Colors.cyan,
                      unselectedLabelColor: Colors.grey,
                      position: TabBarPosition.bottom,
                    ),
                    key: tabKey,
                    tabs: const [
                      Text('All'),
                      Text('Favorites'),
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
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: deviceHeight * 0.04),
            child: FloatingActionButton(
              tooltip: 'Add Note',
              onPressed: () {
                final newNote = Note(
                  title: '',
                  body: '',
                  isFavorite: false,
                  color: Colors.transparent,
                );
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
