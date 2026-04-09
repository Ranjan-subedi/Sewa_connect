import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sewa_connect/provider/active_task.dart';
import 'package:sewa_connect/provider/service_details.dart';
import 'package:sewa_connect/services/geo_locator.dart';

class ProviderDashboardPage extends StatefulWidget {
  final String job;
  final String providerName;

  const ProviderDashboardPage({
    super.key,
    required this.job,
    required this.providerName,
  });

  @override
  State<ProviderDashboardPage> createState() => _ProviderState();
}

class _ProviderState extends State<ProviderDashboardPage> {

  double? myLat;
  double? myLng;


  Stream<QuerySnapshot<Map<String, dynamic>>> fetchServices()  async*{
    final activeTask = await FirebaseFirestore.instance.collection("Accepted Services")
    .where("acceptedBy", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .where("taskStatus", isEqualTo: "running")
    .get();


    if(activeTask.docs.isNotEmpty){
       yield* FirebaseFirestore.instance
          .collection("Accepted Services")
          .where("acceptedBy", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("taskStatus", isEqualTo: "running")
          .snapshots();

    }else{
      yield* FirebaseFirestore.instance
          .collection("Accepted Services")
          .where("service", isEqualTo: widget.job)
          .where("isTaken", isEqualTo: false)
          .snapshots();
    }

  }

  Future<void> getMyLocation() async {
    final position = await GeoLocatorServices().getCurrentLocation();

    if (position != null) {
      setState(() {
        myLat = position.latitude;
        myLng = position.longitude;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Dashboard"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
        stream: fetchServices(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Services to show !"));
          }
          if (myLat == null || myLng == null) {
            return Center(child: CircularProgressIndicator());
          }

          final availableServices = snapshot.data!.docs.toList();

          availableServices.sort((a, b) {
            final dataA = a.data();
            final dataB = b.data();

            final locA = dataA["Location"];
            final locB = dataB["Location"];

            double distA = Geolocator.distanceBetween(
              myLat!,
              myLng!,
              locA["latitude"],
              locA["longitude"],
            );

            double distB = Geolocator.distanceBetween(
              myLat!,
              myLng!,
              locB["latitude"],
              locB["longitude"],
            );

            return distA.compareTo(distB);
          });

          return ListView.builder(
            itemCount: availableServices.length,
            itemBuilder: (context, index) {
              final docId = availableServices[index].id;
              final name = availableServices[index].data()["name"];
              final phone = availableServices[index].data()["phone"];
              final service = availableServices[index].data()["service"];
              final photo = availableServices[index].data()["photo"];
              final location = availableServices[index].data()["Location"];
              final double latitude = location["latitude"];
              final double longitude = location["longitude"];
              final dateTime = availableServices[index].data()["timestamp"];

              double distance = Geolocator.distanceBetween(
                myLat!,
                myLng!,
                latitude,
                longitude,
              );

              double distanceInKm = distance/1000;

              return GestureDetector(
                onTap: () async{
                  final providerId =  FirebaseAuth.instance.currentUser!.uid;

                  final  activeTask = await FirebaseFirestore.instance
                      .collection("Accepted Services")
                      .where("acceptedBy", isEqualTo: providerId)
                      .where("taskStatus", isEqualTo: "running")
                      .get();

                  if(activeTask.docs.isNotEmpty){

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ActiveTaskPage(docId: docId,);
                    },));

                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailsPage(
                          providerName: widget.providerName,
                          docId: docId,
                          dateTime: dateTime,
                          photo: photo,
                        ),
                      ),
                    );
                  }

                },
                child: Container(
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
                            child: Hero(
                              tag: dateTime,
                              child: CachedNetworkImage(
                                imageUrl: photo,
                                fit: BoxFit.cover,
                                width: 52,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        ),

                        subtitle: Text(phone.toString()),


                        trailing: Column(
                          children: [
                            Text(dateTime.toDate().toString()),
                            Text("${distanceInKm.toStringAsFixed(2)} away"),
                          ],
                        ),

                        // visualDensity: VisualDensity(vertical: 4),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
