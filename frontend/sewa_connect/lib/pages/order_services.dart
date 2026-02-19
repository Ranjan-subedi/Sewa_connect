import 'package:flutter/material.dart';

class OrderServicesPage extends StatefulWidget {
  const OrderServicesPage({super.key});

  @override
  State<OrderServicesPage> createState() => _OrderServicesState();
}

class _OrderServicesState extends State<OrderServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
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
            )
          ],
        ),
      ),
    );
  }
}
