import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/admin/request_profile.dart';

import '../services/database_services.dart';

class AddWorkerPage extends StatefulWidget {
  const AddWorkerPage({super.key});

  @override
  State<AddWorkerPage> createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  Stream<QuerySnapshot> ? fetchWorkApplication;

  getOnLoad()async{
    fetchWorkApplication = DatabaseServices().addWorker();
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
        title: Text("Add Worker"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(stream: fetchWorkApplication,
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

                  return GridView.builder(
                    itemCount: workApplication.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2
                      ),
                      itemBuilder: (context, index) {
                      final name = workApplication[index]["name"];
                      final phone = workApplication[index]["phone"];
                      final image = workApplication[index]["applicantPhoto"];
                      final job = workApplication[index]["job"];
                      final docId = workApplication[index].id;
                      return InkWell(
                        onTap: () {
                          print(docId);
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              RequestProfilePage(
                                phone: phone,
                                docId: docId,
                                name: name,
                                image: image,
                                job: job,
                              ),));
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                  child: CachedNetworkImage(
                                      imageUrl: image,
                                    placeholder:(context, url) {
                                      return const Center(child: CircularProgressIndicator(),);
                                    },
                                    errorWidget: (context, url, error) =>const Center(child: Icon(Icons.error),),
                                  )
                                  // Image.network(
                                  //   image,
                                  //   fit: BoxFit.cover,
                                  //   width: double.infinity,
                                  // )
                              ),
                              Text(name, style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),),
                              Text(job),
                            ],
                          ),
                          
                          
                        ),
                      );
                      },);

                },)
            ),
            // Center(child: Text("Workers")),
            // Expanded(child: ListView.builder(
            //   itemCount: 4,
            //   itemBuilder: (context, index) {
            //   return  Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Material(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //       elevation: 3,
            //       child: InkWell(
            //         onTap: () {
            //           // Navigator.push(context, MaterialPageRoute(builder: (context) => RequestProfilePage(),));
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //               color: Colors.white,
            //               shape: BoxShape.circle
            //           ),
            //           height: 80,
            //           width: MediaQuery.of(context).size.width,
            //           child: Row(
            //             children: [
            //               Lottie.asset('assets/lottie/LoadingElephant.json'),
            //               Spacer(),
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Text('Dipesh Subedi',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            //                   Text('Plumber',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),),
            //                 ],
            //               ),
            //               Spacer(),
            //               IconButton(onPressed: () {
            //                 // Navigator.push(context, MaterialPageRoute(builder: (context) => RequestProfilePage(),));
            //               }, icon: Icon(Icons.add)),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   );
            // },))
          ],
        ),
      ),
    );
  }
}
