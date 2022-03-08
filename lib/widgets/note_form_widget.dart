import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/drawer_screen.dart';

class NoteFormWidget extends StatelessWidget {
  const NoteFormWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.onChangedTitle,
    required this.onChangedContent,
  }) : super(key: key);

  final String title;
  final String content;
  final ValueChanged onChangedTitle;
  final ValueChanged onChangedContent;

  @override
  Widget build(BuildContext context) {
    if(DrawerScreen.activ) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //     Visibility(
          //     visible: DrawerScreen.asyncM().toString()=="true",
          // child:
          TextFormField(
            maxLines: null,
            initialValue: title,
            style: TextStyleConstants.titleStyle1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.title,
            ),
            validator: (value) =>
            value!.length > 50
                ? AppLocalizations.of(context)!
                .title_should_not_exceed_50_characters
                : null,
            onChanged: onChangedTitle,
            textInputAction: TextInputAction.next,
            // )
          ),
          // Visibility(
          // visible: DrawerScreen.asyncM().toString()=="true",
          // child:

          TextFormField(
            maxLines: null,
            initialValue: content,
            style: TextStyleConstants.contentStyle2,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.note_body,
            ),
            validator: (value) =>
            value!.isEmpty ? AppLocalizations.of(context)!.blank_note : null,
            onChanged: onChangedContent,
            textInputAction: TextInputAction.done,
            // )
          )

        ],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //     Visibility(
          //     visible: DrawerScreen.asyncM().toString()=="true",
          // child:
          // Visibility(
          // visible: DrawerScreen.asyncM().toString()=="true",
          // child:
      Padding(
      padding: const EdgeInsets.all(5.0),
    child: Text(
            title,
            style: TextStyleConstants.titleStyle1,
          )),
    Padding(
    padding: const EdgeInsets.all(5.0),
    child:  Text(
            content,
            style: TextStyleConstants.contentStyle2,
    )),

        ],
      );
    }
  }
}
