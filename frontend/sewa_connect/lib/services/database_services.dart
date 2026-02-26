
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final firebasefirestore = FirebaseFirestore.instance;

  Future addService({required String service, required Map<String, dynamic> category})async{
    await firebasefirestore.collection("Services").doc(service).collection("providers").add(category);
  }


  Future<QuerySnapshot<Map<String, dynamic>>> getAllServices()async{
    return await firebasefirestore.collection("Services").get();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getCategoryService(String categoryId)async{
    return await firebasefirestore.collection("Services").doc(categoryId).collection("providers").snapshots();
  }

  Future<void> setOrder({required Map<String, dynamic> data})async{
    await firebasefirestore.collection("Orders").add(data);
  }

  Future<void> deleteOrder({required String orderId})async{
    await firebasefirestore.collection("Orders").doc(orderId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allOrder(){
    return firebasefirestore.collection("Orders").snapshots();
  }


  //For testing map only
  Future<QuerySnapshot> getLocation()async{
    return await firebasefirestore.collection("Orders").get();
  }

  // need to be modified later for specific Users
  Stream<QuerySnapshot<Map<String, dynamic>>> myOrder(){
    return firebasefirestore.collection("Orders").snapshots();
  }







}