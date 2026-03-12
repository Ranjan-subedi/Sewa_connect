import 'package:flutter/material.dart';

class AllAcceptedOrderPage extends StatefulWidget {
  const AllAcceptedOrderPage({super.key});

  @override
  State<AllAcceptedOrderPage> createState() => _AllAcceptedOrderPageState();
}

class _AllAcceptedOrderPageState extends State<AllAcceptedOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accepted Order"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
    );
  }
}
