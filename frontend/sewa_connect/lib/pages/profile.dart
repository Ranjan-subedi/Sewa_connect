import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/utils/cloudinary_upload.dart';

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
                    onTap: () {
                      Navigator.pop(context); // close drawer
                      // Navigate to home page
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings
                    },
                  ),
                  Divider(), // a line to separate logout
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {
                      Navigator.pop(context);
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
