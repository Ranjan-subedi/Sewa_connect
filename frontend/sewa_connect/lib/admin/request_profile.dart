import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RequestProfileage extends StatefulWidget {


  @override
  State<RequestProfileage> createState() => _RequestProfilePageState();
}

class _RequestProfilePageState extends State<RequestProfileage> {
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
                child: Lottie.asset('assets/lottie/LoadingElephant.json'),
              ),
              SizedBox(height: 20,),
              Text('Plumber man', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
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
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withAlpha(200),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Icon(Icons.trending_up_sharp),
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                          color: Colors.red.withAlpha(150),
                          borderRadius: BorderRadius.circular(8)
                      ),
                    child: Icon(Icons.crop_square_sharp),
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
