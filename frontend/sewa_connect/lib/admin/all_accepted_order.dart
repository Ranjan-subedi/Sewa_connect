import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_services.dart';

class AllAcceptedOrderPage extends StatefulWidget {
  const AllAcceptedOrderPage({super.key});

  @override
  State<AllAcceptedOrderPage> createState() => _AllAcceptedOrderPageState();
}

class _AllAcceptedOrderPageState extends State<AllAcceptedOrderPage> {

  Stream<QuerySnapshot>? fetchallAcceptedServices;

  getOnLoad()async{
    fetchallAcceptedServices = DatabaseServices().allAcceptedOrder();
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accepted Order"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: fetchallAcceptedServices,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                  return Center(
                    child: Text("No work Application"),
                  );
                }
                final workApplication = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: workApplication.length,
                    itemBuilder: (context, index) {

                      final name = workApplication[index]["name"];
                      final address = workApplication[index]["address"];
                      final phone = workApplication[index]["phone"];
                      final acceptedTime = workApplication[index]["timestamp"];
                      print(acceptedTime.toDate().toString());
                      print(acceptedTime.toDate().hour.toString());

                      return Container(
                        margin: EdgeInsets.all(12),
                        child: Material(
                          color: Colors.white,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(name,style: TextStyle(color: Colors.grey[600])),
                                Text(address),
                                Text(phone),
                                Text(acceptedTime.toDate().toString(), overflow: TextOverflow.ellipsis,maxLines: 1,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },

                  ),
                );


              },)
        ],
      ),
    );
  }
}
