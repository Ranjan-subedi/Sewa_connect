import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> initialize({required String userId})async{
    await firebaseMessaging.requestPermission();

    String? token =await firebaseMessaging.getToken();

    await firebaseFirestore.collection("Users").doc(userId).update(
      {
        "fmtoken": token,
      }
    );

    FirebaseMessaging.onMessage.listen((event) {
      print("foreground notification: ${event.notification?.title}");
    },);
  }

  Future<void> saveNotification({
    required String title,
    required String body,
    required String userId,
  })async{
    await firebaseFirestore.collection("Notifications").add({
      "userId": userId,
      "isRead": false,
      "title": title,
      "body": body,
      "timestamp" : FieldValue.serverTimestamp(),
    });
  }

  Future<void> markAsRead(String id) async {
    await firebaseFirestore.collection("notifications").doc(id).update({
      "isRead": true,
    });
  }



}