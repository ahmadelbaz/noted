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

Map<int, Color> color = {
  50: const Color.fromRGBO(48, 48, 48, 1),
  100: const Color.fromRGBO(48, 48, 48, 1),
  200: const Color.fromRGBO(48, 48, 48, 1),
  300: const Color.fromRGBO(48, 48, 48, 1),
  400: const Color.fromRGBO(48, 48, 48, 1),
  500: const Color.fromRGBO(48, 48, 48, 1),
  600: const Color.fromRGBO(48, 48, 48, 1),
  700: const Color.fromRGBO(48, 48, 48, 1),
  800: const Color.fromRGBO(48, 48, 48, 1),
  900: const Color.fromRGBO(48, 48, 48, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF303030, color);

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
            primarySwatch: colorCustom,
            primaryColor: const Color(0xFF303030),
            indicatorColor:
                ref.watch(isDarkStateProvider) ? Colors.white : Colors.black,
            hintColor: Colors.grey,
            highlightColor: const Color(0xffFCE192),
            hoverColor: ref.watch(isDarkStateProvider)
                ? const Color(0xff3A3A3B)
                : const Color(0xff4285F4),
            focusColor: ref.watch(isDarkStateProvider)
                ? const Color(0xff0B2512)
                : const Color(0xffA8DAB5),
            disabledColor: Colors.grey,
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
                      : const ColorScheme.light(),
                ),
            appBarTheme: const AppBarTheme(
              elevation: 0.0,
            ),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const NotesScreen(),
        '/add_edit_note': (context) => const AddEditNoteScreen(),
      },
    );
  }
}
