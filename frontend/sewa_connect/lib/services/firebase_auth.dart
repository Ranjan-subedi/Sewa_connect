import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {



  Future register({required String name, required String email, required String password})async{
    try{
      final  credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);

      try{
        await FirebaseFirestore.instance.collection("Users")
            .doc(credential.user!.uid)
            .set({
          "isProvider": false,
          "role": "user",
          "name": name,
          "email": email,
          "password": password,
          "created at": DateTime.now(),
        });
      }catch(e){
        print(e);
      }

    }on FirebaseException catch(e){
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }catch(e){
      print("something got error $e");
    }
  }



  Future<String?> login({required String email, required String password})async{
    try{
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return null;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No account found with this email';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password';
      } else {
        return 'Login error try again';
      }
    }catch(e){
      return "something got error $e";
    }

  }

  Future<void> logout()async{
    await FirebaseAuth.instance.signOut();
  }
}