import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app_flutter_sqflite_provider/constants/assets_path.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionName,

}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(

          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(actionName),
        ),
      ],
    ),
  );
}

void showNewFeatureNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.alert),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            maxLines: null,
            // initialValue: content,
            // style: TextStyleConstants.contentStyle2,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.note_body,
            ),
            validator: (value) =>
            value!.isEmpty ? AppLocalizations.of(context)!.blank_note : null,
            textInputAction: TextInputAction.done,
          ),
          Image.asset(
            AssetsPath.coding,
            width: 100,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          // Text(
          //   AppLocalizations.of(context)!
          //       .feature_is_under_development_coming_soon,
          //   textAlign: TextAlign.center,
          // )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        )
      ],
      actionsAlignment: MainAxisAlignment.center,
    ),
  );
}
