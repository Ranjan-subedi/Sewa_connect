import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActiveTaskPage extends StatelessWidget {
  final String docId;

  const ActiveTaskPage({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Active Task")),

      body: Column(
        children: [
          Text("Name"),
          Text("Services"),

          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("Accepted Services")
                  .doc(docId)
                  .update({
                "taskStatus": "completed",
              });

              Navigator.pop(context); // go back
            },
            child: Text("Complete Task"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("Accepted Services")
                  .doc(docId)
                  .update({
                "taskStatus": "completed",
              });

              Navigator.pop(context); // go back
            },
            child: Text("Complete Task"),
          )
        ],
      )
    );
  }
}