import 'package:flutter/material.dart';

Widget customListTile(VoidCallback ontap, String title, IconData icon) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.white,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    onTap: ontap,
  );
}
