import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
   FlutterLocalNotificationsPlugin _flutterLocalNotifications = FlutterLocalNotificationsPlugin();
    String? notificationToken;



  Future<void> showNotification(RemoteMessage remoteMessage)async{
    // notification channel for id and name 
    // AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel("high_importance_channel" , "high_importance_channel",description: 'This channel is used for important notifications.',playSound: true,importance: Importance.high,);
    const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

    // Android notification 
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(androidNotificationChannel.id, androidNotificationChannel.name,importance: Importance.high,priority: Priority.high,ticker: 'ticker',channelDescription: "channel description");
    // Android notification details
    DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentBadge: true,presentSound: true,presentAlert: true,);

    // notification details for android and ios
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails,iOS: darwinNotificationDetails);
    // Future.delayed(Duration.zero,(){
     await _flutterLocalNotifications.show(1, remoteMessage.notification!.title,remoteMessage.notification!.body, notificationDetails);
    // });

    // Push the notification to Frontend
    await localNotificationInitilization(remoteMessage);
  }

   Future<void> localNotificationInitilization(RemoteMessage remotemessage)async{

    var androidInitilization= AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitilization= DarwinInitializationSettings();

    var initilizationSettings= InitializationSettings(android: androidInitilization, iOS: iosInitilization);

    await _flutterLocalNotifications.initialize(initilizationSettings,onDidReceiveNotificationResponse: (notification_response) {
      
    },);
   }
  Future<void> listenToNotifications()async{
    FirebaseMessaging.onMessage.listen((remotemessage) async{
     if(kDebugMode){
      print(remotemessage.notification!.android!.channelId);
      print(remotemessage.notification!.title);
      print(remotemessage.notification!.body);
     }
     // call shownotifications function
     await showNotification(remotemessage);
     });
  }
  Future<String?> getDeviceToken()async {
    notificationToken = await firebaseMessaging.getToken();

    // subscribe to onTokenRefresh stream so that every token expires now token is generated it will be updated here
    FirebaseMessaging.instance.onTokenRefresh
    .listen((fcmToken) {
      notificationToken = fcmToken;
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    })
    .onError((err) {
      // Error getting token.
    });
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