import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewa_connect/pages/homepage.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/pages/work_application.dart';
import 'package:sewa_connect/services/firebase_auth.dart';
import 'package:sewa_connect/utils/cloudinary_upload.dart';

import '../provider/dashboard.dart';
import '../services/sharedpreferences.dart';
import 'nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? profileImage;
  String? email;
  String? uid;



  getOnLoad()async{
    email = await FirebaseAuth.instance.currentUser!.email;
    uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      print(email);
      print(uid);
    });
  }

  Future<void> getUserRole()async{
    final roleDoc = await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    if(roleDoc.exists){
      final isProvider = roleDoc.data()!["isProvider"];
      final job = roleDoc.data()!["job"];
      final name = roleDoc.data()!["name"];


      if(!isProvider){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You are not provider")));
        return ;
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDashboardPage(job: job,providerName: name,),));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnLoad();

  }



  @override
  Widget build(BuildContext context) {
    return
      Container(
        // margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Ranjan Subedi'),
                        SizedBox(width: 20,),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.cover,
                              child:uid == null ?  Center(child: CircularProgressIndicator()) : Text(uid.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(
                                decoration: TextDecoration.underline
                              ),)
                          ),
                        ),
                        SizedBox(width: 20,),

                      ],
                    ),
                    accountEmail: Text(email.toString()),

                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.black,
                      child:profileImage != null ? Icon(Icons.person) :
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text('Sewa_connect',)),
                      ),
                    ),
                  ),
                  // Drawer items
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () {
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text("Work Application"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WorkApplicationPage(),));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.switch_right_outlined),
                    title: Text("Switch my role"),
                    onTap: ()async {
                      getUserRole();
                    },
                  ),
                  Divider(), // a line to separate logout
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: ()async {
                      SharedPreferencesHelper().setLoginState(state: false);
                      await FirebaseAuthServices().logout().then((value) {
                        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage(),));
                      },);
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      );
  }
}
