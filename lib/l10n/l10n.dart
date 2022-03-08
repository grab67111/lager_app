import 'package:flutter/material.dart';

class L10n {
  static const all = [
    Locale('ru'),
    Locale('en'),
   ];

  static String getLanguage({required String code}) {
    switch (code) {
      case 'ru':
        return 'Русский (ru)';
      case 'en':
        return 'English (en)';
      default:
        return '';
    }
  }
}
