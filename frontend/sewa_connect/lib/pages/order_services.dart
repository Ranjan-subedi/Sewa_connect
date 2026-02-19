import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderServicesPage extends StatefulWidget {
  final String name;
  final String photo;

  const OrderServicesPage({
    required this.name,
    required this.photo,
});

  @override
  State<OrderServicesPage> createState() => _OrderServicesState();
}

class _OrderServicesState extends State<OrderServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3
                )
              ),
              child: Center(child: Text(widget.photo)),
            ),

            SizedBox(height: 20,),
            
            Text("Name : Ranjan Subedi"),
            SizedBox(height: 10,),

            Text("Address : Pokhara"),
            SizedBox(height: 10,),

            Text("Phone : 9812345678"),
            SizedBox(height: 10,),

            Text("Email : Email@gmail.com"),
            SizedBox(height: 10,),
            
            Text("Experience : 5+ yrs")

          ],
        ),
      ),
    );
  }
}
