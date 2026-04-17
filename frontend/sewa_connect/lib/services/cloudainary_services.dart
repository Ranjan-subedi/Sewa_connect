import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CloudainaryServices {
  final cloudName = dotenv.env["CLOUD_NAME"];
  final uploadPreset = dotenv.env["UPLOAD_PRESET"];

  late final url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );

  Future<String?> uploadImage({
    required String folderName,
    required String imageFile,
  }) async {
    if (cloudName == null || cloudName!.isEmpty) return null;
    if (uploadPreset == null || uploadPreset!.isEmpty) return null;

    final request = http.MultipartRequest("POST", url);

    request.fields["upload_preset"] = uploadPreset!;
    request.fields["folder"] = folderName;

    request.files.add(
      await http.MultipartFile.fromPath("file", imageFile),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(responseBody);
      return responseData["secure_url"] as String?;
    } else {
      return null;
    }
  }
}
