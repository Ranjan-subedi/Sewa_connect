import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/model/add_service_model.dart';
import 'package:sewa_connect/pages/services_category.dart';
import 'package:sewa_connect/services/database_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Widget> caurasolItems = [
    Lottie.asset('assets/lottie/LoadingElephant.json'),
    Container(color: Colors.red,height: 200,),
    Lottie.asset('assets/lottie/loadingHand.json'),
    Container(color: Colors.lightBlue,height: 200,),
    Lottie.asset('assets/lottie/Sandy_Loading.json'),
    Container(color: Colors.lightGreen,height: 200,),
  ];

  // List<AddServiceModel> services= [
  //   AddServiceModel(name: 'Plumber', photo: 'https://lottie.host/821e1ebb-4de0-47ff-b6f1-92cf0c644503/5JfNofBvGA.json'),
  //   AddServiceModel(name: 'Electrician', photo: "https://lottie.host/33600080-6c39-4afb-9e30-fa3da75fce5c/2Wy9mjlwB8.json"),
  //   AddServiceModel(name: 'Carpenter', photo: "https://lottie.host/5db8cc07-ef43-4ef3-8df8-9f3dc3a1eb01/MKzyhOTCNC.json"),
  //   AddServiceModel(name: 'Painter', photo: "https://lottie.host/9ff8ced5-98d5-4364-ae2b-37795e936c61/7yJpGXZw4m.json"),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      // Scaffold(
      // appBar: AppBar(
      //   title: Text("Sewa Connect"),
      //   centerTitle: true,
      //   // foregroundColor: Theme.of(context).colorScheme.surface,
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      // ),
      //
      // body:
      Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.surface,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Welcome"),
                      SizedBox(height: 10),
                      Text('Ranjan'),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                        ),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.search)),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  ClipRRect(
                    // borderRadius: BorderRadius.circular(50),
                    child: Icon(Icons.person , color: Theme.of(context).colorScheme.primary,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [Text("Services"), Text("All")],
            // ),

            SizedBox(height: 20),

            CarouselSlider(
              items: caurasolItems.map((e) => Container(
                margin: EdgeInsets.all(8),
                child: e,
              ),).toList(),


              options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true
              ),
            ),

            SizedBox(height: 20,),

            Text('Services ', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),

            // SizedBox(height: 20,),

            Expanded(
              child: FutureBuilder(
                  future: DatabaseServices().getAllServices(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(!snapshot.hasData){
                      return Center(child: Text("No Data Found"),);
                    }
                    final allServices = snapshot.data!.docs;

                    return
                      GridView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: allServices.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 12
                          ), itemBuilder: (context, index) {
                        final  jobTitle = allServices[index]["name"] ?? "";
                        final photo = allServices[index]["photo"] ?? "";
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ServicesCategoryPage(
                                        categoryId: allServices[index].id,
                                        categoryName: jobTitle),));
                                },
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.deepPurple[300],
                                  ),
                                  child: Column(
                                    children: [
                                      Lottie.network(photo, fit: BoxFit.cover,height: 150, width: 180),
                                      Text(jobTitle),
                                    ],
                                  ),
                                ),
                              );
                            },);
                  }
                  ),
            )


          ],
        ),
      // ),
          );
  }
}
