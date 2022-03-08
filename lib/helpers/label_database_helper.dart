import 'dart:convert';

import 'package:note_app_flutter_sqflite_provider/helpers/database_helper.dart';
import 'package:note_app_flutter_sqflite_provider/models/label.dart';
import 'package:http/http.dart' as http;

class LabelDatabaseHelper {
  static final LabelDatabaseHelper instance = LabelDatabaseHelper._init();
  LabelDatabaseHelper._init();

  Future<Label> getRecord(int id) async {

    print("1233333333333333333  333333  getRecord " );

    final db = await DatabaseHelper.instance.database;

    final records = await db.query(
      labelTable,
      where: '${LabelField.id} = ?',
      whereArgs: [id],
    );

    if (records.isNotEmpty) {
      return Label.fromJson(records.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

     Future<List<Label>>  getAllRecords() async {
    print("1233333333333333333  333333 getAllRecords  " );

    var response = await http.get(Uri.parse('http://85.192.12.236:3512/all_label'),
         headers: {"Content-Type": "application/json",
        "Accept": "application/json",
        }
     );
    final records = response.body;
       List<Label> list = [];
      List<dynamic> json_label = jsonDecode(records)["label"];
      for (int i=0; i<json_label.length; i++){
        list.add(Label.fromJson(json_label[i]));
      }

    print("list: "+list.toString());

     return list  ;
  }

  Future<int> insertRecord(Label label) async {
    var response1 =  await http.post(Uri.parse('http://85.192.12.236:3512/label'),
        // body: {"label": _labelController.text.trim()},
        body: json.encode({"label": label.title}),
        headers: {"Content-Type": "application/json"}

    );


    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      labelTable,
      label.toJson(),
    );
  }

  Future<int> updateRecord(Label label) async {

    print("123333333333333333333333333333333333333333333333333333333333333   "+label.toJson().toString());
    var response1 = await http.post(Uri.parse('http://85.192.12.236:3512/label_update'),
        body: json.encode(label.toJson()),
        headers: {"Content-Type": "application/json"}

    );
    print("22222222   "+ response1.body);


    final db = await DatabaseHelper.instance.database;

    return await db.update(
      labelTable,
      label.toJson(),
      where: '${LabelField.id} = ?',
      whereArgs: [label.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    var response1 = await http.get(Uri.parse('http://85.192.12.236:3512/label_delete/'+id.toString()),
        headers: {"Content-Type": "application/json"}

    );

    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      labelTable,
      where: '${LabelField.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllRecords() async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(labelTable);
  }
}
