import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerView extends ConsumerWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Drawer(
      backgroundColor: Colors.teal,
    );
  }
}
