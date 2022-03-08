import 'package:flutter/material.dart';

const String noteTable = 'Note';

class NoteField {
  static const String id_a = 'id_a';
  static const String a_title = 'a_title';
  static const String a_content = 'a_content';
  static const String imagePaths = 'imagePaths';
  static const String bgcolors_id = 'bgcolors_id';
  static const String a_time_create = 'a_time_create';
  static const String labels_id = 'labels_id';
  static const String users_id = 'users_id';
}

class Note {
  final String id_a;
  final String a_title;
  final String a_content;
  final String labels_id;
  final List<String> imagePaths;
  final Color bgcolors_id;
  final DateTime a_time_create;
  final String users_id;

  Note({
    required this.id_a,
    required this.a_title,
    required this.a_content,
    required this.a_time_create,
    required this.labels_id,
    required this.imagePaths,
    required this.bgcolors_id,
    required this.users_id,
  });

  static Note fromJson(Map<String, Object?> json) {

    // print('asd'+(const Color(0xff292B2D)as int).toString());

      print("7777777777777777777777777777777 "+Note(
    id_a: json[NoteField.id_a].toString(),
        a_title: json[NoteField.a_title].toString(),
        a_content: json[NoteField.a_content].toString(),
        a_time_create: DateTime.parse(json[NoteField.a_time_create].toString()),
        labels_id: '',
  //      labels_id: json[NoteField.labels_id].toString(),
  //       imagePaths: [''],
       imagePaths: json[NoteField.imagePaths].toString().isEmpty
           ? []
           : json[NoteField.imagePaths].toString().split('||'),
        bgcolors_id: Color(0xffa3cef1),
       // bgcolors_id: Color(json[NoteField.bgcolors_id] as int),
    users_id: json[NoteField.users_id].toString(),
      ).toJson().toString());


  return  Note(
    id_a: json[NoteField.id_a].toString(),
    a_title: json[NoteField.a_title].toString(),
    a_content: json[NoteField.a_content].toString(),
    a_time_create: DateTime.parse(json[NoteField.a_time_create].toString()),

         labels_id: json[NoteField.labels_id].toString(),
    // imagePaths: [''],
    imagePaths:
    // json[NoteField.imagePaths].toString().isEmpty
    //   ?
    [],
    // : json[NoteField.imagePaths].toString().split('||'),
    // bgcolors_id: Color(0xff292B2D),
      bgcolors_id: Color(int.parse(json[NoteField.bgcolors_id].toString())),
    users_id: json[NoteField.users_id].toString(),
  );
  }
  Map<String, Object?> toJson() => {
        NoteField.id_a: id_a,
        NoteField.a_title: a_title,
        NoteField.a_content: a_content,
        NoteField.labels_id: labels_id,
        NoteField.bgcolors_id: bgcolors_id.value,
        NoteField.imagePaths: imagePaths.isEmpty ? '' : imagePaths.join('||'),
        NoteField.a_time_create: a_time_create.toIso8601String(),
        NoteField.users_id: users_id,
      };

  Note copy({
    String? id,
    String? title,
    String? content,
    String? label,
    List<String>? imagePaths,
    Color? bgColor,
    DateTime? createdTime,
    String? owner,
  }) =>
      Note(
        id_a: id ?? this.id_a,
        a_title: title ?? this.a_title,
        a_content: content ?? this.a_content,
        a_time_create: createdTime ?? this.a_time_create,
        labels_id: label ?? this.labels_id,
        imagePaths: imagePaths ?? this.imagePaths,
        bgcolors_id: bgColor ?? this.bgcolors_id,
        users_id: owner ?? this.users_id,
      );
}
