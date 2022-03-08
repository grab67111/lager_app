import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/models/label.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app_flutter_sqflite_provider/models/note.dart';
import 'package:note_app_flutter_sqflite_provider/providers/label_provider.dart';
import 'package:note_app_flutter_sqflite_provider/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/drawer_screen.dart';
class DialogActivate extends StatefulWidget {
  const DialogActivate({
    Key? key,
    this.label,
  }) : super(key: key);

  final Label? label;

  @override
  State<DialogActivate> createState() => _DialogActivateState();
}

class _DialogActivateState extends State<DialogActivate> {
  final _labelController = TextEditingController();

  bool _isSubmitted = false;

  String? get _errorMessage {
    final text = _labelController.text.trim();
    if (text.isEmpty) {
      return AppLocalizations.of(context)!.label_cannot_be_empty;
    }
    // if (text.length > 30) {
    //   return AppLocalizations.of(context)!
    //       .label_can_not_be_more_than_30_characters;
    // }

    // final indexLabelExist =
    //     Provider.of<LabelProvider>(context, listen: false).items.indexWhere(
    //           (e) => e.title.toLowerCase() == text.toLowerCase(),
    //         );
    // if (indexLabelExist != -1) {
    //   return AppLocalizations.of(context)!.label_already_exists;
    // }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.label?.title ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _labelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _labelController,

      builder: (context, value, child) => AlertDialog(
        title:
            Text("Подтвердить аккаунт"),

        content: TextField(
          controller: _labelController,
          autofocus: true,
          decoration: InputDecoration(
            errorText: _isSubmitted ? _errorMessage : null,
          ),
          style: TextStyleConstants.contentStyle3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('');
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(

            onPressed: _labelController.value.text.isNotEmpty ? _submit : null,
            child:
                  Text("Подтвердить")

          )
        ],
      ),
    );
  }

  _submit() {
    setState(() {
      _isSubmitted = true;
    });

    if (_errorMessage == null) {

        _addLabel();


      Navigator.of(context).pop(_labelController.text.trim());
    }
  }

  _addLabel() async {
    final prefs = await SharedPreferences.getInstance();

// Save an integer value to 'counter' key.


    // print("123333333333333333333333333333333333333333333333333333333333333   "+action!);




    var response1 = await http.post(Uri.parse('http://85.192.12.236:3512/activation_code'),
        body: json.encode({"action": _labelController.text.trim()}),
        headers: {"Content-Type": "application/json"}

    );
    Map pp = json.decode(response1.body);


    print("22222222 1  "+ response1.body);
    print("22222222   "+ pp["ree"].toString());
    if(pp["ree"].toString() =="1"){
      DrawerScreen.activ = true;
    }
    await prefs.setString('action',pp["ree"].toString());

    final String? action = prefs.getString('action');

    ////////// print("11111   "+json.encode({'name':'test','num':'10'}));
    // var response1 =  await http.post(Uri.parse('http://192.168.161.33:3511/label'),
    //     // body: {"label": _labelController.text.trim()},
    //     body: json.encode({"label": _labelController.text.trim()}),
    //     headers: {"Content-Type": "application/json"}
    //
    // );
    //  print("22222222   "+ response1.body);


    // final label = Label(
    //   title: _labelController.text.trim(),
    // );

    // context.read<LabelProvider>().add(label);
  }

  _updateLabel() {
    String newTitle = _labelController.text.trim();

    final label = widget.label!.copy(title: newTitle);

    Provider.of<LabelProvider>(context, listen: false).update(label).then((value) =>{
    Provider.of<NoteProvider>(context, listen: false).fetchAndSet()
    }

    );

    //* update note when label changed

    List<Note> temptNotes = Provider.of<NoteProvider>(context, listen: false)
        .items
        .where((e) => e.labels_id == widget.label!.title)
        .toList();

    List<Note> notesDidUpdated =
        temptNotes.map((e) => e.copy(label: newTitle)).toList();

    for (var element in notesDidUpdated) {
      context.read<NoteProvider>().update(element);
    }
  }
}
