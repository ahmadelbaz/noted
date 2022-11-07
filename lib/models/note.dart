import 'package:noted/models/database_model.dart';
import 'package:uuid/uuid.dart';

// @immutable
class Note implements DatabaseModel {
  String? uuid;
  String? title;
  String? body;
  DateTime? createdDate;
  DateTime? updatedDate;
  bool? isFavorite;
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
        createdDate: createdDate,
        updatedDate: title == this.title && body == this.body
            ? updatedDate
            : DateTime.now(),
        isFavorite: isFavorite ?? this.isFavorite,
      );

  @override
  bool operator ==(covariant Note other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Notes(name: $title, body: $body, uuid: $uuid)';

  // Handle the data that is coming from db
  Note.fromMap(Map<String, dynamic> map) {
    // Convert int to DateTime (becauze we cant store DateTime type in sqlite)
    DateTime newCreatedDateTime =
        DateTime.fromMillisecondsSinceEpoch(map['createddate']);
    DateTime newUpdatedDateTime =
        DateTime.fromMillisecondsSinceEpoch(map['updateddate']);
    // Convert int to bool (cuz sqlite doesn't have bool so we use int instead)
    final newIsFavorite = map['isfavorite'] == 1 ? true : false;
    uuid = map['id'];
    title = map['title'];
    body = map['body'];
    createdDate = newCreatedDateTime;
    updatedDate = newUpdatedDateTime;
    isFavorite = newIsFavorite;
  }

  @override
  String? database() {
    return 'notes_database';
  }

  @override
  String? getId() {
    return uuid;
  }

  @override
  String? table() {
    return 'notes';
  }

  @override
  Map<String, dynamic>? toMap() {
    // Convert DateTime to int
    int storedCreatedDateTime = createdDate!.millisecondsSinceEpoch;
    int storedUpdatedDateTime = updatedDate!.millisecondsSinceEpoch;
    // Convert bool to int to store it in db
    final newIsFavorite = isFavorite ?? false ? 1 : 0;

    return {
      'id': uuid,
      'title': title,
      'body': body,
      'createddate': storedCreatedDateTime,
      'updateddate': storedUpdatedDateTime,
      'isfavorite': newIsFavorite,
    };
  }
}
