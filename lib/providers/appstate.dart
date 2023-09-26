import 'dart:io';

import 'package:alemeno/services/cloud_service.dart';
import 'package:flutter/material.dart';

import '../services/notification_service.dart';

// ignore: must_be_immutable
class AppState extends ChangeNotifier {

    NotificationService notificationService = NotificationService();

  // List<String> _images = [];
  Future<void> saveImageToFirestore(File file) async {
    // database code
    DataBaseService dataBaseService = DataBaseService();
   String? fcmtoken = await notificationService.getDeviceToken();
    await dataBaseService.saveImage(File(file.path)); //saving image to database
    await dataBaseService.sendNotificationDynamic(fcmtoken!,"Hello,", "Thank you for sharing  food with me");
    notificationService.listenToNotifications();
    notifyListeners();
  }
}
