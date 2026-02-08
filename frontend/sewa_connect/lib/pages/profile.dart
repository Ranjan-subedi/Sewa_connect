import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/utils/cloudinary_upload.dart';

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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          title: Text("Profile Page"), centerTitle: true),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Upload Data"),
            Text("From and Too to Cloudaniry !"),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(color: Colors.black),
              child: profileImageUrl != null
                  ?  Image.network(profileImageUrl!, fit: BoxFit.cover)
                  :  InkWell(
                onTap: () {
                  uploadImage();
                },
                  child: Icon(Icons.add_a_photo_rounded, size: 45,color: Colors.white,)),
            ),
            ElevatedButton(
              onPressed: () async{
              },
              child: Text("Upload"),
            ),
            Text("Name: Ranjan Subedi"),
            Text("email: RanjanSubedi@gmail.com"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage(),)),),
    );
  }
}
