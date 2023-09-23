import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  void listenToNotifications()async{
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title);
      print(message.notification!.body);
     });
  }
  Future<String?> getDeviceToken()async {
    String? notificationToken=await firebaseMessaging.getToken();
    return notificationToken!;
  }
  void requestNotification_permission()async{
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