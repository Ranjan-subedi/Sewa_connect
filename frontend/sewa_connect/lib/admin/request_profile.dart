import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/video/analytics/video_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RequestProfilePage extends StatefulWidget {
  final String name;
  final String phone;
  final String job;
  final String image;
  final String docId;

  const RequestProfilePage(
      {required this.docId,
        required this.name,
        required this.phone,
        required this.job,
        required this.image
      });


  @override
  State<RequestProfilePage> createState() => _RequestProfilePageState();
}

class _RequestProfilePageState extends State<RequestProfilePage> {


  Future<void> acceptApplication({required String docId, required String phone})async{
    FirebaseFirestore firestore = await FirebaseFirestore.instance;

    DocumentSnapshot profile = await firestore.collection("Work Application").doc(docId).get();

    // if(!profile.exists){
    //   print("Document not exists");
    //   return ;
    // }

    Map<String, dynamic> workerData = profile.data() as Map<String, dynamic>;
    String job = workerData["job"];
    String uid = workerData["userId"];
    print(uid);

    await firestore.collection("Services").doc(job).collection("providers").doc(phone).set(
        {
          "name": workerData["name"],
          "phone": workerData["phone"],
          "photo": workerData["applicantPhoto"] ?? "",
          "isProvider": true,
          "verifiedAt": Timestamp.now(),
        }
    );

    await firestore.collection("Work Application")
        .doc(docId)
        .update(
        {
          "isProvider": true,
          "status": "accepted"
        });

    await firestore.collection("Users")
        .doc(uid)
        .update(
        {
          "job": job,
          "isProvider": true,
          "verifiedAt": Timestamp.now(),
        }
    );


  }

  Future<void> rejectApplication({required String docId})async{
    FirebaseFirestore firestore = await FirebaseFirestore.instance;

    await firestore.collection("Work Application").doc(docId).update({"status": "rejected"});

    Future.delayed(Duration(days: 1), () async {
      await firestore.collection("Work Application").doc(docId).delete();
    },);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Profile"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2
                  )
                ),
                child:widget.image == "" ?
                Lottie.asset('assets/lottie/LoadingElephant.json') :
                    Image.network(widget.image,fit: BoxFit.cover,)
                ,
              ),
              SizedBox(height: 20,),
              Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Text('I am good plumber with 5 years experience. I have got certificate of level 3 CTEVT ', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),),
              SizedBox(height: 20,),
              Text('Citizen Ship Card(front)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Lottie.asset('assets/lottie/loadingHand.json', fit: BoxFit.cover, height: 320)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text('Citizen Ship Card(back)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Lottie.asset('assets/lottie/loadingHand.json', fit: BoxFit.cover, height: 320)),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Text('Certificate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Lottie.asset('assets/lottie/loadingHand.json', fit: BoxFit.cover, height: 320)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      try {

                        await acceptApplication(
                            docId: widget.docId,
                            phone: widget.phone
                        );

                        Navigator.pop(context);

                      } catch (e) {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e.toString())));

                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withAlpha(200),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Icon(Icons.offline_pin),
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      await rejectApplication(docId: widget.docId);
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: BoxDecoration(
                            color: Colors.red.withAlpha(150),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      child: Icon(Icons.crop_square_sharp),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
