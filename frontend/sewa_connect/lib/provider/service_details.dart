import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatefulWidget {
  final photo;
  final dateTime;
  final docId;
  final providerName;
  const ServiceDetailsPage({
    super.key,
    required this.photo,
    required this.docId,
    required this.dateTime,
    required this.providerName,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Service Details Page"), centerTitle: true),
      body: Container(
        child: Column(
          children: [
            Hero(
              tag: widget.dateTime,
              child: CachedNetworkImage(
                imageUrl: widget.photo,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            SizedBox(height: 10),
            Text(widget.providerName),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final myTask = await FirebaseFirestore.instance
                        .collection("Accepted Services")
                        .where(
                          "acceptedBy",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .where("taskStatus", isEqualTo: "running")
                        .get();

                    if (myTask.docs.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Finish your running Task !")),
                      );
                      return;
                    }

                    final snapshot = await FirebaseFirestore.instance
                        .collection("Accepted Services")
                        .doc(widget.docId)
                        .get();

                    Map<String, dynamic> data =
                        snapshot.data() as Map<String, dynamic>;

                    if (data["isTaken"] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Already accepted !")),
                      );
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection("Accepted Services")
                        .doc(widget.docId)
                        .update({
                          "acceptedBy": FirebaseAuth.instance.currentUser!.uid,
                          "isTaken": true,
                          "taskStatus": "running",
                        });
                  },
                  child: Text("Accept"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
