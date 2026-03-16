import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CloudainaryServices {
  final cloudName = dotenv.env["CLOUD_NAME"];
  final uploadPreset = dotenv.env["UPLOAD_PRESET"];

  late final url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  Future uploadImage(
      {required String folderName,
        required String imageFile})async
  {
    final request = http.MultipartRequest("POST", url);
    
    request.fields["upload_preset"] = uploadPreset!;
    request.fields["folder"] = folderName;
    
    request.files.add(
      await http.MultipartFile.fromPath("file", imageFile),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if(response.statusCode == 200){
      final responseData = jsonDecode(responseBody);
      return responseData["secure_url"];
    }else{
      return null;
    }
    
  }



}
