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
    if(notificationSettings.authorizationStatus == AuthorizationStatus.authorized){
      print("Permission granted");
    }
    else if(notificationSettings.authorizationStatus == AuthorizationStatus.provisional){
      print("Permission provisional");
    }
    else if(notificationSettings.authorizationStatus == AuthorizationStatus.denied){
      print("Permission denied");
    }
    print("Permission result "+notificationSettings.authorizationStatus.toString());
  }}