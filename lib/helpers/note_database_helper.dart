import 'package:note_app_flutter_sqflite_provider/helpers/database_helper.dart';
import 'package:note_app_flutter_sqflite_provider/models/note.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NoteDatabaseHelper {
  static final NoteDatabaseHelper instance = NoteDatabaseHelper._init();
  NoteDatabaseHelper._init();

  Future<Note> getRecord(int id) async {
    final db = await DatabaseHelper.instance.database;

    final records = await db.query(
      noteTable,
      where: '${NoteField.id_a} = ?',
      whereArgs: [id],
    );

    if (records.isNotEmpty) {
      return Note.fromJson(records.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> getAllRecords() async {
    print('zxczxczxcz   getAllRecordsgetAllRecordsgetAllRecordsgetAllRecordsgetAllRecordsgetAllRecords');
    var response = await http.get(Uri.parse('http://85.192.12.236:3512/all_note'),
        headers: {"Content-Type": "application/json",
          "Accept": "application/json",
          "Access-Control-Expose-Headers": "*"}

    );

    print('response '+response.body);

    final records = response.body;

    List<Note> list = [];
    List<dynamic> json_label = jsonDecode(records)["article"];
     for (int i=0; i<json_label.length; i++){

      list.add(Note.fromJson(json_label[i]));
    }
    // final db = await DatabaseHelper.instance.database;
    //
    //
    // final records = await db.query(
    //   noteTable,
    //   orderBy: '${NoteField.createdTime} DESC',
    // );
    print('1111111 '+list.toString());

    return list;
  }

  Future<int> insertRecord(Note note) async {

    print("123333333333333333333333333333333333333333333333333333333333333   "+note.toJson().toString());
    var response1 = await http.post(Uri.parse('http://85.192.12.236:3512/article'),
        body: json.encode(note.toJson()),
        headers: {"Content-Type": "application/json"}

    );
    print("22222222   "+ response1.body);


    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      noteTable,
      note.toJson(),
    );
  }

  Future<int> updateRecord(Note note) async {

    print("123333333333333333333333333333333333333333333333333333333333333   "+note.toJson().toString());
    var response1 = await http.post(Uri.parse('http://85.192.12.236:3512/article_update'),
        body: json.encode(note.toJson()),
        headers: {"Content-Type": "application/json"}

    );
    print("22222222   "+ response1.body);


    final db = await DatabaseHelper.instance.database;

    return await db.update(
      noteTable,
      note.toJson(),
      where: '${NoteField.id_a} = ?',
      whereArgs: [note.id_a],
    );
  }

  Future<int> changeFieldValueOfAllRecords({
    required String field,
    required String value,
  }) async {
    final db = await DatabaseHelper.instance.database;

    return await db.rawUpdate('UPDATE $noteTable SET $field = ?', [value]);
  }

  Future<int> deleteRecord(String id) async {

    var response1 = await http.get(Uri.parse('http://85.192.12.236:3512/article_delete/'+id),
        headers: {"Content-Type": "application/json"}

    );
    print("22222222   "+ response1.body);



    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      noteTable,
      where: '${NoteField.id_a} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllRecords() async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(noteTable);
  }
}
