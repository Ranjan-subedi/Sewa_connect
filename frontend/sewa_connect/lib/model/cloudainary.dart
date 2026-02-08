import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> uploadImageToCloudinary({
  required BuildContext context,
  required File file,
  required String cloudName,
  required String uploadPreset,
}) async {
  try {
    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(respStr);
      return data['secure_url']; // This is the Cloudinary image URL
    } else {
      print('Upload failed: $respStr');
      return null;
    }
  } catch (e) {
    print('Upload error: $e');
    return null;
  }
}
