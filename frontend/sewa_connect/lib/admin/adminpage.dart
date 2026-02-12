import 'package:flutter/material.dart';
import 'package:sewa_connect/admin/add_worker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    height: 80,
                    child: Row(
                      children: [
                        Spacer(),
                        Text("Add Worker"),
                        Spacer(),
                        IconButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddWorkerPage(),));
                        },icon: Icon(Icons.work)),
                        Spacer()
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
