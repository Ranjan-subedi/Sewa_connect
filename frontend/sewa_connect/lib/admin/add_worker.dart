import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/admin/request_profile.dart';

class AddWorkerPage extends StatefulWidget {
  const AddWorkerPage({super.key});

  @override
  State<AddWorkerPage> createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Worker"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Center(child: Text("Workers")),
            Expanded(child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RequestProfileage(),));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Lottie.asset('assets/lottie/LoadingElephant.json'),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Dipesh Subedi',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              Text('Plumber',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),),
                            ],
                          ),
                          Spacer(),
                          IconButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RequestProfileage(),));
                          }, icon: Icon(Icons.add)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },))
          ],
        ),
      ),
    );
  }
}
