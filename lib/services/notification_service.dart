import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  void requestNotification_permission()async{
   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
   NotificationSettings notificationSettings= await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    print(notificationSettings.authorizationStatus);
  }}