import 'package:flutter/material.dart';

class ServiceAddPage extends StatefulWidget {
  const ServiceAddPage({super.key});

  @override
  State<ServiceAddPage> createState() => _ServiceAddPageState();
}

class _ServiceAddPageState extends State<ServiceAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Add Service"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("What Service you want to Add", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                labelText: "Enter Service Name",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

          ],
        ),
      ),
      
    );
  }
}
