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
    return FirebaseFirestore.instance.collection("Accepted Services").where("name", isEqualTo: "Electrician").snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchdata;

   Future<void> getOnTheLoad()async{
     fetchdata = fetchServices();
     setState(() {
     });
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnTheLoad();
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
        onRefresh: () async =>getOnTheLoad(),
        child: StreamBuilder(stream: fetchdata,
            builder: (context,AsyncSnapshot snapshot) {
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
                      margin: EdgeInsets.all(12),
                      height: 100,
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: ListTile(
                            title: Text(
                              "Ranjan Summmmmmmmmmmmmmmm,,,,,mbedi",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            leading: ClipRRect(
                              child: CircleAvatar(
                                radius: 26,
                                child: Text("R"),
                              ),
                            ),

                            subtitle: Text("9800000000"),
                            // visualDensity: VisualDensity(vertical: 4),

                          ),
                        ),
                      ),
                    );
                  },);

            },
        ),
      ),
    );
  }
}
