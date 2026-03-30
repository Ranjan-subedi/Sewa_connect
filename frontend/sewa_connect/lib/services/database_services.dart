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
}
