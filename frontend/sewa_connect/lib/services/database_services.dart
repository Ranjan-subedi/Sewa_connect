import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final firebasefirestore = FirebaseFirestore.instance;

  Future addService({
    required String service,
    required Map<String, dynamic> category,
  }) async {
    await firebasefirestore
        .collection("Services")
        .doc(service)
        .collection("providers")
        .add(category);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllServices() async {
    return await firebasefirestore.collection("Services").get();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getCategoryService(
    String categoryId,
  ) async {
    return await firebasefirestore
        .collection("Services")
        .doc(categoryId)
        .collection("providers")
        .snapshots();
  }

  Future<void> setOrder({required Map<String, dynamic> data}) async {
    await firebasefirestore.collection("Orders").add(data);
  }

  Future<bool> isProviderFreeAtSlot({
    required String providerRef,
    required DateTime scheduleAt,
  }) async {
    final normalized = DateTime(
      scheduleAt.year,
      scheduleAt.month,
      scheduleAt.day,
      scheduleAt.hour,
      scheduleAt.minute,
    );

    final slotSnapshot = await firebasefirestore
        .collection("Orders")
        .where("providerRef", isEqualTo: providerRef)
        .where("scheduleAt", isEqualTo: Timestamp.fromDate(normalized))
        .where("status", whereIn: ["pending", "accepted"])
        .limit(1)
        .get();

    return slotSnapshot.docs.isEmpty;
  }

  Future<void> deleteOrder({required String orderId}) async {
    await firebasefirestore.collection("Orders").doc(orderId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allOrder() {
    return firebasefirestore
        .collection("Orders")
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  void updateStatus(String docId) async {
    DocumentSnapshot orderDoc = await firebasefirestore
        .collection("Orders")
        .doc(docId)
        .get();
    Map<String, dynamic> data = orderDoc.data() as Map<String, dynamic>;
    final userId = data["userId"];

    data["status"] = "accepted";
    data["isTaken"] = false;

    await firebasefirestore
        .collection("Accepted Services")
        .doc(docId)
        .set(data);

    await firebasefirestore.collection("Orders").doc(docId).update(data);
    // await firebasefirestore.collection("Orders").doc(docId).delete();
  }

  //For testing map only
  Future<QuerySnapshot> getLocation() async {
    return await firebasefirestore.collection("Orders").get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> myOrder({required String email}) {
    return firebasefirestore
        .collection("Orders")
        .where("email", isEqualTo: email)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allAcceptedOrder() {
    return firebasefirestore.collection("Accepted Services").snapshots();
  }

  Stream<QuerySnapshot> addWorker() {
    return firebasefirestore
        .collection("Work Application")
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> providerReviews({
    required String providerRef,
    required String service,
  }) {
    return firebasefirestore
        .collection("Reviews")
        .where("providerRef", isEqualTo: providerRef)
        .where("service", isEqualTo: service)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> submitReview({
    required String orderId,
    required String userId,
    required String email,
    required String providerRef,
    required String providerName,
    required String service,
    required int rating,
    required String review,
  }) async {
    if (rating < 1 || rating > 5) {
      throw Exception("Rating must be between 1 and 5");
    }

    final orderRef = firebasefirestore.collection("Orders").doc(orderId);

    await firebasefirestore.runTransaction((transaction) async {
      final orderSnap = await transaction.get(orderRef);
      if (!orderSnap.exists) {
        throw Exception("Order not found");
      }

      final orderData = orderSnap.data()!;
      if (orderData["isReviewed"] == true) {
        throw Exception("You already rated this service");
      }
      if (orderData["status"]?.toString() != "completed") {
        throw Exception("You can only rate completed services");
      }

      final reviewRef = firebasefirestore.collection("Reviews").doc();
      transaction.set(reviewRef, {
        "orderId": orderId,
        "userId": userId,
        "email": email,
        "providerRef": providerRef,
        "providerName": providerName,
        "service": service,
        "rating": rating,
        "review": review,
        "timestamp": FieldValue.serverTimestamp(),
      });

      transaction.update(orderRef, {"isReviewed": true});

      if (providerRef.isNotEmpty && service.isNotEmpty) {
        final providerRefDoc = firebasefirestore
            .collection("Services")
            .doc(service)
            .collection("providers")
            .doc(providerRef);

        final providerSnap = await transaction.get(providerRefDoc);
        if (providerSnap.exists) {
          final currentTotal =
              (providerSnap.data()?["totalRating"] as num?)?.toInt() ?? 0;
          final currentCount =
              (providerSnap.data()?["reviewCount"] as num?)?.toInt() ?? 0;
          final newCount = currentCount + 1;
          final newTotal = currentTotal + rating;

          transaction.update(providerRefDoc, {
            "totalRating": newTotal,
            "reviewCount": newCount,
            "averageRating": newTotal / newCount,
          });
        }
      }
    });
  }
}
