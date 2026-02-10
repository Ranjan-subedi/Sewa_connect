import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sewa Connect"),
        centerTitle: true,
        // foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Services"), Text("All")],
            ),

            SizedBox(height: 20),

            CarouselSlider(
              items: caurasolItems.map((e) => Container(
                margin: EdgeInsets.all(8),
                child: e,
              ),).toList(),


              options: CarouselOptions(
                  height: 250,
                  enlargeCenterPage: true,
                  autoPlay: true
              ),
            ),

            SizedBox(height: 20,),

            Text('Required Services ', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),

            SizedBox(height: 20,),

            Expanded(

              child: GridView.builder(
                padding: EdgeInsets.all(8),
                itemCount: 14,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2
                    ), itemBuilder: (context, index) {
                        return Container(
                          height: 200,
                          width: 200,
                          color: Colors.deepPurple[300],
                        );
                      },),
            )


          ],
        ),
      ),
    );
  }
}
