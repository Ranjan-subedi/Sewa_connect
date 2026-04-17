import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/services/cloudainary_services.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';

class WorkApplicationPage extends StatefulWidget {
  const WorkApplicationPage({super.key});

  @override
  State<WorkApplicationPage> createState() => _WorkApplicationPageState();
}

class _WorkApplicationPageState extends State<WorkApplicationPage> {
  late TextEditingController famousName;
  late TextEditingController phoneNumber;

  File? image;
  bool isUploading = false;

  getSharedImage() async {
    final imagePath = await SharedPreferencesHelper().getimage();
    if (imagePath != null) {
      image = File(imagePath);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedImage();
    famousName = TextEditingController();
    phoneNumber = TextEditingController();
  }

  final imagepicker = ImagePicker();

  Future<void> getImage([ImageSource source = ImageSource.camera]) async {
    setState(() {
      isUploading = true;
    });

    try {
      final pickedImage = await imagepicker.pickImage(source: source);

      if (pickedImage != null) {
        image = File(pickedImage.path);
        await SharedPreferencesHelper().saveimage(imagePath: image!.path);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No image selected")));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Image pick failed: $e")));
      }
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> _chooseImageSource() async {
    if (isUploading) return;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Take photo"),
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> uploadWorkApplication(String applicantPhoto) async {
    final query = await FirebaseFirestore.instance
        .collection("Work Application")
        .where("phone", isEqualTo: phoneNumber.text)
        .get();

    if (query.docs.isEmpty) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      print("Subbmiting uid $uid");
      await FirebaseFirestore.instance.collection("Work Application").add({
        "userId": uid,
        "name": famousName.text.trim(),
        "phone": phoneNumber.text.trim(),
        "job": currentjobselected,
        "applicantPhoto": applicantPhoto,
        "status": "pending",
        "isProvider": false,
        "specialCertificate": "Certificate Photo",
        "citizenshipFront": "CitizenShip Front Photo",
        "citizenshipBack": "CitizenShip Back Photo",
        "applicationDate": DateTime.now(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("applied")));
      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Already applied")));
      return false;
    }
  }

  List<String> selectjob = ["Plumber", "Electrician", "Carpenter", "Painter"];
  String? currentjobselected;

  Future<void> _submitApplication() async {
    if (image == null ||
        famousName.text.trim().isEmpty ||
        phoneNumber.text.trim().isEmpty ||
        currentjobselected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all required fields first.")),
      );
      return;
    }

    setState(() => isUploading = true);
    try {
      final applicantPhoto = await CloudainaryServices().uploadImage(
        folderName: "WorkApplication",
        imageFile: image!.path,
      );
      if (applicantPhoto == null || applicantPhoto.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image upload failed. Please try again."),
          ),
        );
        return;
      }

      final submitted = await uploadWorkApplication(applicantPhoto);
      if (!mounted) return;
      if (submitted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    famousName.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Application"),
        foregroundColor: Colors.white,
        backgroundColor: theme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.primary.withAlpha(70)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.primary,
                      child: const Icon(
                        Icons.work_outline,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Apply as ${currentjobselected ?? 'a service provider'}",
                        style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: const Radius.circular(12),
                  dashPattern: const [6, 8],
                  color: theme.primary,
                  strokeWidth: 1.6,
                ),
                child: InkWell(
                  onTap: _chooseImageSource,
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.surface,
                    ),
                    child: isUploading
                        ? Center(
                            child: Lottie.asset(
                              "assets/lottie/LoadingElephant.json",
                              fit: BoxFit.cover,
                            ),
                          )
                        : image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _chooseImageSource,
                                icon: Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 64,
                                  color: theme.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Tap to upload profile photo",
                                style: TextStyle(
                                  color: theme.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 220,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: _chooseImageSource,
                                    icon: Icon(
                                      Icons.edit,
                                      color: theme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _sectionTitle("Personal Details"),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                controller: famousName,
                decoration: InputDecoration(
                  hintText: "Your calling name",
                  labelText: "Name",
                  filled: true,
                  fillColor: theme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                keyboardType: TextInputType.number,
                controller: phoneNumber,
                decoration: InputDecoration(
                  hintText: "9800000000",
                  labelText: "Phone number",
                  filled: true,
                  fillColor: theme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Preferred job",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: theme.surface,
                ),
                hint: const Text("Choose your skill"),
                value: currentjobselected,
                items: selectjob.map((e) {
                  return DropdownMenuItem<String>(value: e, child: Text(e));
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    currentjobselected = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _docPlaceholder("Citizenship Card (Front)"),
              const SizedBox(height: 12),
              _docPlaceholder("Citizenship Card (Back)"),
              const SizedBox(height: 12),
              _docPlaceholder("Special Certificate"),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isUploading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  isUploading ? "Submitting..." : "Submit Application",
                ),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
    );
  }

  Widget _docPlaceholder(String title) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white38,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          SizedBox(
            width: 90,
            child: Lottie.asset(
              'assets/lottie/loadingHand.json',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
