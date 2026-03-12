import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {

  Future login({required String email, required String password})async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future register({required String email, required String password})async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance.collection("User")
        .add({
      "role":"user",
      "email":email,
      "password":password,
      "created at": DateTime.timestamp(),
    });
  }

}