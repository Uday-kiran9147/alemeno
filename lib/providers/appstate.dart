import 'dart:io';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppState extends ChangeNotifier {
  List<String> _images = [];
  Future<void> saveImageToFirestore(File file) async {
    // call to database
    // get the URL
    _images.add("URL");
    notifyListeners();
  }
}
