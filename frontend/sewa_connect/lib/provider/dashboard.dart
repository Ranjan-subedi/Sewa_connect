import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderDashboardPage extends StatefulWidget {
  const ProviderDashboardPage({super.key});

  @override
  State<ProviderDashboardPage> createState() => _ProviderState();
}

class _ProviderState extends State<ProviderDashboardPage> {

   Stream<QuerySnapshot<Map<String, dynamic>>> fetchServices(){
    return FirebaseFirestore.instance.collection("Services").where("job", isEqualTo: "Plumber").snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Dashboard"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: RefreshIndicator(
        onRefresh: () async => initState(),
        child: Container(
          child: StreamBuilder(stream: fetchServices(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                  return Center(child: Text("No Services Available !"),);
                }
                final availableServices= snapshot.data!.docs;

                return ListView.builder(
                    itemCount: availableServices.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        color: Colors.red,
                      );
                    },);

              },
          ),
        ),
      ),
    );
  }
}
