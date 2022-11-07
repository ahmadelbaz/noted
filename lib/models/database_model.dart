
// Model for db, that all models in db inherates from it
class DatabaseModel {
  String? table() {
    return null;
  }

  String? database() {
    return null;
  }

  String? getId() {
    return null;
  }

  Map<String, dynamic>? toMap() {
    return null;
  }

  DatabaseModel.fromMap(Map<String, dynamic> map);
}
