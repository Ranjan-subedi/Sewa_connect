import 'package:flutter/material.dart';

class OrderServicesPage extends StatefulWidget {
  const OrderServicesPage({super.key});

  @override
  State<OrderServicesPage> createState() => _OrderServicesPageState();
}

class _OrderServicesPageState extends State<OrderServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Services'),
      ),
    );
  }
}
