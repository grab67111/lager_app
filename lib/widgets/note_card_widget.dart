import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/models/note.dart';

import 'images_staggered_grid_view_widget.dart';
import 'label_card_widget.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.bgcolors_id,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: note.bgcolors_id == ColorsConstant.bgScaffoldColor
              ? Colors.grey
              : note.bgcolors_id,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.imagePaths.isNotEmpty)
            ImagesStaggeredGridViewWidget(
              imagePaths: note.imagePaths,
              limitedQuantity: LimitedQuantity.yes,
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.a_title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      note.a_title,
                      style: TextStyleConstants.titleStyle2,
                      maxLines: 2,
                    ),
                  ),
                Text(
                  note.a_content,
                  style: TextStyleConstants.contentStyle3,
                  maxLines: 5,
                ),
                if (note.labels_id.isNotEmpty) LabelCardWidget(title: note.labels_id)
              ],
            ),
          )
        ],
      ),
    );
  }
}
