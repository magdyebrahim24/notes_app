import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  Map get setting;
  Map get home;
  Map get search;
  Map get addNote;
  Map get toast;
  Map get addMemory;
  Map get discardAndSaveAlert;
  String get cancelBtn;
  String get discardBtn;


}
