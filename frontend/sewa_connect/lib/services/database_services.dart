
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final firebasefirestore = FirebaseFirestore.instance;

  Future addService({required String service, required Map<String, dynamic> category})async{
    await firebasefirestore.collection("Services").doc(service).collection("providers").add(category);
  }



}