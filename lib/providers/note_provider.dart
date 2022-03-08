import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/helpers/note_database_helper.dart';
import 'package:note_app_flutter_sqflite_provider/models/note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _items = [];

  List<Note> get items => [..._items];

  List<Note> itemsByLabel(String titleLabel) =>
      _items.where((e) => e.labels_id == titleLabel).toList();

  Future fetchAndSet() async {
    print("1233333333333333333  333333 fetchAndSet NoteProvider  " );

    _items = await NoteDatabaseHelper.instance.getAllRecords();
    notifyListeners();
  }

  Future add(Note note) async {
    print("1233333333333333333  333333 add NoteProvider  " );

    _items.insert(0, note);
    notifyListeners();
    await NoteDatabaseHelper.instance.insertRecord(note);
  }

  Future update(Note note) async {
    print("1233333333333333333  333333 update NoteProvider  " );

    final index = _items.indexWhere((e) => e.id_a == note.id_a);

    if (index != -1) {
      _items[index] = note;
      notifyListeners();
      await NoteDatabaseHelper.instance.updateRecord(note);
    }
  }

  Future delete(String id) async {
    _items.removeWhere((e) => e.id_a == id);
    notifyListeners();
    await NoteDatabaseHelper.instance.deleteRecord(id);
  }

  Future deleteAll() async {
    _items.clear();
    notifyListeners();
    await NoteDatabaseHelper.instance.deleteAllRecords();
  }

  Future removeLabelContent({required String content}) async {
    int n = _items.length;
    for (var i = 0; i < n; i++) {
      if (_items[i].labels_id == content) {

        var newNote = _items[i].copy(label: '');
        _items[i] = newNote;

        await NoteDatabaseHelper.instance.updateRecord(newNote);
      }
    }
    notifyListeners();
  }

  Future removeAllLabelContent() async {
    _items = [..._items.map((e) => e.copy(label: '')).toList()];
    notifyListeners();
    await NoteDatabaseHelper.instance
        .changeFieldValueOfAllRecords(field: NoteField.labels_id, value: '');
  }
}
