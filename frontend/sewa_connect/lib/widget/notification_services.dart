import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  NotificationServices._();
  static final NotificationServices _instance = NotificationServices._();
  factory NotificationServices() => _instance;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _localInitialized = false;

  Future<void> initialize({required String userId}) async {
    await firebaseMessaging.requestPermission();

    if (!_localInitialized) {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const settings = InitializationSettings(android: android);
      await _localNotifications.initialize(settings);
      _localInitialized = true;
    }

    final token = await firebaseMessaging.getToken();
    if (token != null) {
      await firebaseFirestore.collection("Users").doc(userId).set(
        {"fmtoken": token},
        SetOptions(merge: true),
      );
    }

    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? 'Sewa Connect';
      final body = message.notification?.body ?? '';
      if (body.isNotEmpty) {
        _showLocalNotification(title: title, body: body);
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> userNotifications(String userId) {
    return firebaseFirestore
        .collection("Notifications")
        .where("userId", isEqualTo: userId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<int> unreadCount(String userId) {
    return userNotifications(userId).map(
      (snap) => snap.docs.where((doc) => doc.data()['isRead'] != true).length,
    );
  }

  Future<void> saveNotification({
    required String title,
    required String body,
    required String userId,
    required String type,
    String? byWhom,
    String? orderId,
  }) async {
    await firebaseFirestore.collection("Notifications").add({
      "userId": userId,
      "isRead": false,
      "title": title,
      "body": body,
      "type": type,
      "byWhom": byWhom,
      "orderId": orderId,
      "timestamp": FieldValue.serverTimestamp(),
    });

    await _showLocalNotification(title: title, body: body);
  }

  Future<void> notifyOrderAccepted({
    required String userId,
    required String byWhom,
    required String serviceName,
    String? orderId,
  }) async {
    await saveNotification(
      userId: userId,
      type: "accepted",
      byWhom: byWhom,
      orderId: orderId,
      title: "Service Accepted",
      body: "$byWhom accepted your $serviceName booking.",
    );
  }

  Future<void> notifyOrderRejected({
    required String userId,
    required String byWhom,
    required String serviceName,
    String? orderId,
  }) async {
    await saveNotification(
      userId: userId,
      type: "rejected",
      byWhom: byWhom,
      orderId: orderId,
      title: "Service Rejected",
      body: "$byWhom rejected your $serviceName booking.",
    );
  }

  Future<void> notifyWorkFinished({
    required String userId,
    required String byWhom,
    required String serviceName,
    String? orderId,
  }) async {
    await saveNotification(
      userId: userId,
      type: "completed",
      byWhom: byWhom,
      orderId: orderId,
      title: "Work Finished",
      body: "$byWhom completed your $serviceName service.",
    );
  }

  Future<void> notifyProviderCancelled({
    required String userId,
    required String byWhom,
    required String serviceName,
    String? orderId,
  }) async {
    await saveNotification(
      userId: userId,
      type: "cancelled",
      byWhom: byWhom,
      orderId: orderId,
      title: "Booking Cancelled",
      body: "$byWhom cancelled your $serviceName booking.",
    );
  }

  Future<void> markAsRead(String id) async {
    await firebaseFirestore.collection("Notifications").doc(id).update({
      "isRead": true,
    });
  }

  Future<void> markAllAsRead(String userId) async {
    final unread = await firebaseFirestore
        .collection("Notifications")
        .where("userId", isEqualTo: userId)
        .where("isRead", isEqualTo: false)
        .get();

    for (final doc in unread.docs) {
      await doc.reference.update({"isRead": true});
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    if (!_localInitialized) return;

    const androidDetails = AndroidNotificationDetails(
      'sewa_connect_channel',
      'Sewa Connect',
      channelDescription: 'Order and service updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
