import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderDashboardPage extends StatefulWidget {
  final String job;

  const ProviderDashboardPage({super.key, required this.job});

  @override
  State<ProviderDashboardPage> createState() => _ProviderState();
}

class _ProviderState extends State<ProviderDashboardPage> {

   Stream<QuerySnapshot<Map<String, dynamic>>> fetchServices(){
    return FirebaseFirestore.instance.collection("Accepted Services").where("service", isEqualTo: widget.job).snapshots();
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
                    final name = availableServices[index].data()["name"];
                    final phone = availableServices[index].data()["phone"];
                    // final service = availableServices[index].data()["service"];
                    final photo = availableServices[index].data()["photo"];


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
                              name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(26),
                              child: CircleAvatar(
                                radius: 26,
                                child: CachedNetworkImage(
                                  imageUrl: photo, fit: BoxFit.cover, width: 52,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error),),
                                ),
                              ),
                            ),

                            subtitle: Text(phone),
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
