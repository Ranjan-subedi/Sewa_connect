import 'package:flutter/material.dart';
import 'package:sewa_connect/services/database_services.dart';

class ServiceAddPage extends StatefulWidget {
  const ServiceAddPage({super.key});

  @override
  State<ServiceAddPage> createState() => _ServiceAddPageState();
}

class _ServiceAddPageState extends State<ServiceAddPage> {
  String? selectedService;
  List<String> serviceAdd = ["Plumber", "Electrician", "Carpenter", "Painter"];




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
                labelText: "Name of Service Providers",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 20,),


            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                hintText: "Select Service",
              ),
              items: serviceAdd.map((e) {
                return DropdownMenuItem(
                  child: Text(e.toString()),
                  value: e,
                );
              },).toList(),
              onChanged: (value) {
                selectedService = value;
              },),
            SizedBox(height: 20,),

            TextField(
              decoration: InputDecoration(
                suffixIcon: Tooltip(
                    message: "For example tap installment for Plumber",
                    child: Icon(Icons.question_mark)),
                filled: true,
                fillColor: Colors.white38,
                labelText: "Category Service In Short (Max 2 word)",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 40,),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  DatabaseServices().addService(service: selectedService!, category: {
                    "name": "Plumber",
                    "photo": "not Yet available !!"

                  });
            }, child: Text("Add Service")
            )
          ],
        ),
      ),
      
    );
  }
}
