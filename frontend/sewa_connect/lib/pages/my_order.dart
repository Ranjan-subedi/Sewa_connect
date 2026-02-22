import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/services/database_services.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List<String> service = ["Plumber", "Electrician", "Carpenter", "Painter"];
  String? selectedService;

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchMyAllOrder;

  getOnTheLoad() async {
    fetchMyAllOrder = DatabaseServices().myOrder();
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
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
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

          Expanded(
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
                  shrinkWrap: true,
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
                              Text(address)],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
