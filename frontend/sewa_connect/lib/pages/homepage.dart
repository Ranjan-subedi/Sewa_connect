import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sewa Connect"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.surface,
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
                      SizedBox(height: 10,),
                      Text('Ranjan')
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface
                          ),
                          child: Icon(Icons.search)),
                    ],
                  ),
                  SizedBox(width: 10,),
                  ClipRRect(
                    // borderRadius: BorderRadius.circular(50),
                    child: Icon(Icons.person),
                  )
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
