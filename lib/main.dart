import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noted/consts.dart';
import 'package:noted/providers/notes_provider.dart';
import 'package:noted/screens/add_edit_note_screen.dart';
import 'package:noted/screens/notes_screen.dart';

// Provider (change notifier) for notes list
final notesChangeNotifierProvider =
    ChangeNotifierProvider((ref) => NoteProvider());

// Provider (State) for theme (Light or Dark)
final isDarkStateProvider = StateProvider<bool>(
  (ref) => true,
);

// Provider (Future) to get the data saved in db before UI
final dataFutureProvider = FutureProvider(
  (ref) async {
    await ref.watch(notesChangeNotifierProvider).getAllNotes();
  },
);

// Provider (State) to use it when we want to change color of any note
final newColorStateProvider = StateProvider<Color>(
  (ref) => Colors.transparent,
);

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      builder: (context, child) {
        // Assign screen height and width to these global variables so we can use them in all screens
        deviceWidth = MediaQuery.of(context).size.width;
        deviceHeight = MediaQuery.of(context).size.height;
        return Theme(
            data: ThemeData(
              primarySwatch: Colors.teal,
              primaryColor: Colors.teal,
              // backgroundColor: ref.watch(isDarkStateProvider)
              //     ? Colors.grey
              //     : const Color(0xffF1F5FB),
              indicatorColor:
                  ref.watch(isDarkStateProvider) ? Colors.white : Colors.black,

              hintColor: Colors.grey,

              highlightColor: ref.watch(isDarkStateProvider)
                  ? const Color(0xff372901)
                  : const Color(0xffFCE192),
              hoverColor: ref.watch(isDarkStateProvider)
                  ? const Color(0xff3A3A3B)
                  : const Color(0xff4285F4),

              focusColor: ref.watch(isDarkStateProvider)
                  ? const Color(0xff0B2512)
                  : const Color(0xffA8DAB5),
              disabledColor: Colors.grey,
              // textSelectionColor: ref.watch(isDarkStateProvider) ? Colors.white : Colors.black,
              cardColor: ref.watch(isDarkStateProvider)
                  ? const Color(0xFF303030)
                  : Colors.white,
              canvasColor: ref.watch(isDarkStateProvider)
                  ? const Color(0xFF303030)
                  : Colors.grey[50],
              brightness: ref.watch(isDarkStateProvider)
                  ? Brightness.dark
                  : Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  colorScheme: ref.watch(isDarkStateProvider)
                      ? const ColorScheme.dark()
                      : const ColorScheme.light()),
              appBarTheme: const AppBarTheme(
                elevation: 0.0,
              ),
            ),
            child: child!);
      },
      debugShowCheckedModeBanner: false,
      // darkTheme:
      //     ref.watch(isDarkStateProvider) ? ThemeData.dark() : ThemeData.light(),
      // themeMode: ThemeMode.dark,

      routes: {
        '/': (context) => const NotesScreen(),
        '/add_edit_note': (context) => const AddEditNoteScreen(),
      },
    );
  }
}
