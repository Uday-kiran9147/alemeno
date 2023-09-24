import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataBaseService implements Data {
  CollectionReference _foodCollection = FirebaseFirestore.instance.collection('food');

  Future<void> saveImage(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("alemeno")
          .child(DateTime.now().microsecond.toString() + "jpeg");

      await ref.putFile(file);
      final imageurl = await ref.getDownloadURL();

      await _foodCollection.add({"image": imageurl});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendNotificationDynamic(String notificationToken,
      String notificationTitle, String notificationBody) async {
    print("token notification " + notificationToken.toString());
    var URL =
        "https://fcm.googleapis.com/fcm/send";
    try {
      final response = await http.post(Uri.parse(URL),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "key=AAAAu1tJAvY:APA91bFZeX9lZ5S2hVTFTj8FQoqM3uiNu0mPMGeHYUFCSYlEsIr53u4dHmbmSw242Y49UembWPq5dWbYrJ4bIyfhLX_6xqOlIh3Y39-stIo87laIac6QIEULC48PksIaKlT-htirCNuF"
          },
          body: json.encode({

            "to": notificationToken,

            "notification": {
              "title": notificationTitle,
              "body": notificationBody,
              "mutable_content": true,
              "sound": "Tri-tone"
            },
          }));
          if(response.statusCode==200){
            print("Notification sent");
          }
          else{
            print("Notification not sent");
          }
    } catch (e) {
      print("Error Occured " + e.toString());
    }
  }
}

abstract class Data {
  Future<void> saveImage(File file);
  Future<void> sendNotificationDynamic(String notificationToken,
      String notificationTitle, String notificationBody);
}
