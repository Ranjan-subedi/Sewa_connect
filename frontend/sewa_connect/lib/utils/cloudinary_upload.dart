import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// Uploads an image from gallery to Cloudinary (unsigned upload).
///
/// Set [cloudName] and [uploadPreset]. Create an unsigned preset in
/// Cloudinary: Settings → Upload → Upload presets → Add → Signing Mode: Unsigned.
///
/// Returns the secure URL of the uploaded image, or null on failure.
Future<String?> uploadImageToCloudinary({
  required BuildContext context,
  required String cloudName,
  required String uploadPreset,
  ImageSource source = ImageSource.gallery,
  int imageQuality = 85,
}) async {
  final picker = ImagePicker();
  final XFile? file = await picker.pickImage(
    source: source,
    imageQuality: imageQuality,
  );
  if (file == null) return null;

  final uri = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
  );
  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', file.path));

  final streamed = await request.send();
  final response = await http.Response.fromStream(streamed);

  if (response.statusCode != 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Upload failed: ${response.statusCode}'),
        ),
      );
    }
    return null;
  }

  final map = jsonDecode(response.body) as Map<String, dynamic>;
  final url = map['secure_url'] as String?;

  if (context.mounted && url != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image uploaded to Cloudinary!')),
    );
  }

  return url;
}
