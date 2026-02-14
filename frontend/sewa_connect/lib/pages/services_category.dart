import 'package:flutter/material.dart';

class ServicesCategoryPage extends StatefulWidget {
  const ServicesCategoryPage({super.key});

  @override
  State<ServicesCategoryPage> createState() => _ServicesCategoryPageState();
}

class _ServicesCategoryPageState extends State<ServicesCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services Category"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        maxCrossAxisExtent: 300),
                      itemBuilder: (context, index) {
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
                              Text('Service Name')
                            ],
                          ),
                        );
                      },),
                )

              ],
        ),
      ),

    );
  }
}
