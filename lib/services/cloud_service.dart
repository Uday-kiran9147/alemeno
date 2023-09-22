import 'dart:io';

class DataBaseService implements Data {
  Future<void> saveImage(File file) async {}
  Future<void> pushNotification() async {}
}

abstract class Data {
  Future<void> saveImage(File file);
  Future<void> pushNotification();
}
