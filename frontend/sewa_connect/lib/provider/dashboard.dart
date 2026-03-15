import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderDashboardPage extends StatefulWidget {
  const ProviderDashboardPage({super.key});

  @override
  State<ProviderDashboardPage> createState() => _ProviderState();
}

class _ProviderState extends State<ProviderDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Dashboard"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

    );
  }
}
