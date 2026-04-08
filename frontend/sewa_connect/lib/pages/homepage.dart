import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/model/add_service_model.dart';
import 'package:sewa_connect/pages/services_category.dart';
import 'package:sewa_connect/services/database_services.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';
import 'package:sewa_connect/widget/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? name;
  Image? profileImage;

  late ColorScheme theme = Theme.of(context).colorScheme;

  getOnTheLoad() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final savedName = await SharedPreferencesHelper().getName();
    if (savedName == "" || savedName == null) {
      final userData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .get();
      name = userData.data()!["name"];
      await SharedPreferencesHelper().saveName(name: name!);
    } else {
      print("Name Found in Shared Preferences");
      name = savedName;
    }

    print(name);

    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  List<Widget> caurasolItems = [
    Lottie.asset('assets/lottie/LoadingElephant.json'),
    Container(color: Colors.red, height: 200),
    Lottie.asset('assets/lottie/loadingHand.json'),
    Container(color: Colors.lightBlue, height: 200),
    Lottie.asset('assets/lottie/Sandy_Loading.json'),
    Container(color: Colors.lightGreen, height: 200),
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
    NotificationServices().initialize(
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    getOnTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.secondary,
                      width: 2
                    )
                  ),
                  child: CircleAvatar(
                      radius: 26,
                      child: Icon(Icons.person_outline, size: 28,),
                    ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        minFontSize: 14,
                          "Hi, $name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                        color: theme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                      ,)),
                      Text("How can we help you today?"),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Badge(
                    // label: Text(2.toString(),),
                    child: IconButton(onPressed: () {

                    }, icon: Icon(Icons.notifications)),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Search",
                suffixIcon: Icon(Icons.search, size: 32,color: Colors.grey,),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none
                )
              ),
            ),
          ),
          SizedBox(height: 30),

          SizedBox(
            child: Column(
              children: [
                Text("Trending Services"),
                CarouselSlider(
                  items: caurasolItems
                      .map(
                        (e) => Container(margin: EdgeInsets.all(8), child: e),
                      )
                      .toList(),

                  options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Services ',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          // SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder(
              future: DatabaseServices().getAllServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No Data Found"));
                }
                final allServices = snapshot.data!.docs;

                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: allServices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final jobTitle = allServices[index]["name"] ?? "";
                    final photo = allServices[index]["photo"] ?? "";
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicesCategoryPage(
                              categoryId: allServices[index].id,
                              categoryName: jobTitle,
                            ),
                          ),
                        );
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
                            Lottie.network(
                              photo,
                              fit: BoxFit.cover,
                              height: 150,
                              width: 180,
                            ),
                            Text(jobTitle),
                          ],
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
      // ),
    );
  }
}
