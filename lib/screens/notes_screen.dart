import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/main.dart';
import 'package:noted/models/note.dart';
import 'package:noted/screens/add_edit_note_screen.dart';

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
          // Instance of the providers we need
          final futureProvider = ref.watch(dataFutureProvider);
          final notesProvider = ref.watch(notesChangeNotifierProvider);
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
                margin: EdgeInsets.symmetric(horizontal: deviceWidth * .06),
                child: notesProvider.count < 1
                    ? const Center(
                        child: Text('Empty! Add Note'),
                      )
                    : ListView.builder(
                        itemCount: notesProvider.count,
                        itemBuilder: (context, index) {
                          final note = notesProvider.notes[index];
                          return note == notesProvider.currentNote &&
                                  notesProvider.canHide
                              ? Container()
                              : Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.all(deviceWidth * 0.02),
                                      padding:
                                          EdgeInsets.all(deviceWidth * 0.009),
                                      child: ListTile(
                                        title: Text(
                                          note.title,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          note.body,
                                          maxLines: 1,
                                        ),
                                        trailing: IconButton(
                                          onPressed: () => notesProvider
                                              .switchFavorite(note),
                                          icon: Icon(
                                            notesProvider.getFavorite(note)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                          ),
                                        ),
                                        onTap: () async {
                                          notesProvider.setCurrentNote(note);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddEditNoteScreen(),
                                            ),
                                          );
                                        },
                                        onLongPress: () {
                                          notesProvider.remove(note);
                                        },
                                      ),
                                    ),
                                    // Divider to separate between items
                                    const Divider(),
                                  ],
                                );
                        },
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

      floatingActionButton: FloatingActionButton(
        //Floating action button on Scaffold
        onPressed: () {
          //code to execute on button press
          final newNote = Note(title: '', body: '', isFavorite: false);
          final notesProvider = ref.watch(notesChangeNotifierProvider);
          notesProvider.add(newNote);
          // notesProvider.setCurrentNote(newNote);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.note_add_rounded), //icon inside button
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //floating action button position to right

      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Colors.teal,
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(right: 90),
              child: IconButton(
                icon: const Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
