import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sewa_connect/services/database_services.dart';
import 'package:sewa_connect/services/geo_locator.dart';

class AllOrderPage extends StatefulWidget {
  const AllOrderPage({super.key});

  @override
  State<AllOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<AllOrderPage> {
  List<String> service = ["Plumber", "Electrician", "Carpenter", "Painter"];
  String? selectedService;

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchMyAllOrder;

  Future<void> getOnTheLoad() async {
    fetchMyAllOrder = DatabaseServices().allOrder();
    setState(() {});
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
        title: Text("Admin Order Page"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              hint: Text('select Service type !'),
              value: selectedService,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              icon: Icon(Icons.arrow_drop_down),
              // decoration
              items: service.map((e) {
                return DropdownMenuItem<String>(value: e, child: Text(e));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                  print(selectedService);
                });
              },
            ),
      
            Divider(),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Text("Geo Location", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),


                  ElevatedButton(onPressed: () async{
                    GeoLocatorServices().getCurrentLocation();
                  }, child: Text("Get Location")),


                ],
              ),
            ),
            SizedBox(height: 20),

            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{
                    await getOnTheLoad();
                  },
                  child: StreamBuilder(
                    stream: fetchMyAllOrder,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No Orders Found"));
                      }
                      if (!snapshot.hasData) {
                        return Center(child: Text("No Data Found"));
                      }

                      final order = snapshot.data!.docs;

                      return ListView.builder(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: order.length,
                        itemBuilder: (context, index) {

                          final name = order[index].data()["name"] ?? "";
                          final email = order[index].data()["email"] ?? "";
                          final address = order[index].data()["address"] ?? "";

                          return Container(
                            margin: EdgeInsets.all(8),
                            child: Material(
                              color: Theme.of(context).colorScheme.primary.withAlpha(130),
                              borderRadius: BorderRadius.circular(12),
                              elevation: 10,
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(name),
                                    Divider(),
                                    SizedBox(height: 20,),
                                    Text(email),
                                    Text(address),
                                  SizedBox(height: 30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(150),
                                            foregroundColor: Theme.of(context).colorScheme.primary
                                          ),
                                          onPressed: () {

                                      }, child: Text("Accept")),
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.red[300],
                                              foregroundColor: Theme.of(context).colorScheme.primary
                                          ),
                                          onPressed: () {
                                            DatabaseServices().deleteOrder(orderId: order[index].id);
                                      }, child: Text("Reject")),
                                    ],
                                  )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
