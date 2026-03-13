import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/pages/work_application.dart';
import 'package:sewa_connect/utils/cloudinary_upload.dart';

import '../provider/dashboard.dart';
import '../services/sharedpreferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? profileImageUrl;
  File? image;

  uploadImage() async {


    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(pickedImage == null )return ;

    image = File(pickedImage.path);
    
    final imageUrl = await  uploadImageToCloudinary(
        context: context,
        cloudName: dotenv.env['CLOUD_NAME'] ?? "",
        uploadPreset: dotenv.env['UPLOAD_PRESET'] ?? "",
    );

    if(imageUrl != null){
      setState(() {
        profileImageUrl = imageUrl;
      });
    }

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
                    accountName: Text('Ranjan Subedi'),
                    accountEmail: Text('Ranjansubedi@gmail.com'),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Text('R'),
                    ),
                  ),
                  // Drawer items
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () {// close drawer
                      // Navigate to home page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {
                      // Navigate to settings
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
                      // Navigate to settings
                      final uid = FirebaseAuth.instance.currentUser!.uid;

                      final userDoc = await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(uid)
                          .get();

                      String role = userDoc["role"];

                      if(role == "provider"){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProviderDashboardPage()));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("You are not a verified provider")));
                      }
                    },
                  ),
                  Divider(), // a line to separate logout
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {
                      // Handle logout
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
