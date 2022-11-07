import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Note {
  final String uuid;
  final String title;
  final String body;
  final DateTime createdDate;
  final DateTime updatedDate;
  final bool isFavorite;
  Note({
    String? uuid,
    required this.title,
    required this.body,
    DateTime? createdDate,
    DateTime? updatedDate,
    required this.isFavorite,
  })  : uuid = uuid ?? const Uuid().v4(),
        createdDate = createdDate ?? DateTime.now(),
        updatedDate = updatedDate ?? DateTime.now();

  Note updated([String? title, body, bool? isFavorite]) => Note(
        uuid: uuid,
        title: title ?? this.title,
        body: body ?? this.body,
        updatedDate: DateTime.now(),
        isFavorite: isFavorite ?? this.isFavorite,
      );

  // String get displayName => '$title ($age years old)';

  @override
  bool operator ==(covariant Note other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $title, body: $body, uuid: $uuid)';
}
