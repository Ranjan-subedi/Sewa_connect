import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/services/database_services.dart';

class ServicesCategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

   const ServicesCategoryPage({
    required this.categoryId,
    required this.categoryName,
});

  @override
  State<ServicesCategoryPage> createState() => _ServicesCategoryPageState();
}

class _ServicesCategoryPageState extends State<ServicesCategoryPage> {
  Stream? categoryStream;

  void getOnTheLoad()async{
    categoryStream = await DatabaseServices().getCategoryService(widget.categoryId);
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
        title: Text(widget.categoryName),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: categoryStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No providers found"));
                      }


                      return GridView.builder(

                        itemCount:snapshot.data.docs.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            maxCrossAxisExtent: 300),
                          itemBuilder: (context, index) {

                          DocumentSnapshot documentSnapshot = snapshot.data.docs[index];

                            return Card(
                              color: Theme.of(context).colorScheme.primary.withAlpha(150),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white
                                      ),
                                      child: Icon(Icons.local_laundry_service, size: MediaQuery.of(context).size.width*0.3,color: Theme.of(context).colorScheme.primary,),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(documentSnapshot["name"])
                                ],
                              ),
                            );
                          },);
                    }
                  ),
                )

              ],
        ),
      ),

    );
  }
}
