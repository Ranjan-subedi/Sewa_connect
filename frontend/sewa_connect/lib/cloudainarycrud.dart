import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CloudinaryCrud extends StatefulWidget {
  const CloudinaryCrud({super.key});

  @override
  State<CloudinaryCrud> createState() => _CloudinaryCrudState();
}

class _CloudinaryCrudState extends State<CloudinaryCrud> {

  File? selectedImage;
  String? cloudainaryImageUrl;

  Future<File?> pickImage()async{
    final image = await ImagePicker();

    final pickimage = await image.pickImage(source: ImageSource.gallery);

    if(pickimage != null){
      selectedImage = File(pickimage.path);
      setState(() {
      });
    }
    return null;
  }


  Future cloudinaryUpload()async{
    final cloudname = dotenv.env["CLOUD_NAME"];
    print(cloudname);
    final uploadPreset = dotenv.env["UPLOAD_PRESET"];
    print(uploadPreset);

    final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudname/image/upload");

    final request = http.MultipartRequest("POST", uri);

      // upload preset
      request.fields["upload_preset"] = uploadPreset! ;

        // image file
        request.files.add(
          await http.MultipartFile.fromPath('file', selectedImage!.path)
        );

        final response = await request.send();

        if(response.statusCode == 200){
          final responseData = jsonDecode(await response.stream.bytesToString());
          setState(() {
            cloudainaryImageUrl = responseData["secure_url"];
          });
          debugPrint(cloudainaryImageUrl);
        }else{
          debugPrint("Error occured");
        }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cloudinary Crud"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      body: Column(
        children: [
          Text("Upload Image"),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: () {
            pickImage();
            setState(() {
            });
          }, child: Text("Pick")),
          ElevatedButton(onPressed: () {
            cloudinaryUpload();
            setState(() {
            });
          }, child: Text("cloudainary apis details")),
          SizedBox(height: 20,),
          Center(child: selectedImage == null ? Container() : Image.file(selectedImage!,fit: BoxFit.cover,height: 200,)),
          SizedBox(height: 20,),
          Text("Here will be from Cloudainary", style: TextStyle(fontSize: 24),),
          Container(
            height: 200,
            // width: 200,
            decoration: BoxDecoration(
              color: Colors.white30
            ),
            child: cloudainaryImageUrl !=  null ? Image.network(cloudainaryImageUrl!, fit: BoxFit.cover,) : Container(),
          )
        ],
      ),
    );
  }
}
