import 'package:flutter/material.dart';

class WorkApplicationPage extends StatefulWidget {
  const WorkApplicationPage({super.key});

  @override
  State<WorkApplicationPage> createState() => _WorkApplicationPageState();
}

class _WorkApplicationPageState extends State<WorkApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Work Application"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3
                ),
                color: Colors.white,
              ),
              child:IconButton(onPressed: () {
              }, icon: Icon(Icons.upload,size: 70, color: Theme.of(context).colorScheme.primary,)),
            )
          ],
        ),
      ),
    );
  }
}
