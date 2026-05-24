import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewa_connect/pages/homepage.dart';
import 'package:sewa_connect/pages/my_order.dart';
import 'package:sewa_connect/pages/notifications_page.dart';
import 'package:sewa_connect/pages/profile.dart';
import 'package:sewa_connect/widget/notification_services.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List<Widget> pages;
  late HomePage homepage;
  late ProfilePage profilePage;
  late MyOrderPage myOrderPage;
  XFile? profileImage;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      NotificationServices().initialize(userId: uid);
    }
    homepage = HomePage();
    profilePage = ProfilePage();
    myOrderPage = MyOrderPage();

    pages = [
      HomePage(),
      MyOrderPage(),
      ProfilePage(),
    ];


  }

  List appBarTitle = [
  "Sewa Connect",
  "Order Services",
  "Profile Page",
  ];



  @override
  Widget build(BuildContext context) {
    String? appbartitle = appBarTitle[_selectedIndex] ;
    return Scaffold(

      appBar: AppBar(
        title: Text(appbartitle!),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          StreamBuilder<int>(
            stream: FirebaseAuth.instance.currentUser?.uid == null
                ? null
                : NotificationServices().unreadCount(
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          count > 9 ? '9+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('Ranjan Subedi'),
                accountEmail: Text('Ranjansubedi@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black,
                child:profileImage != null ? Icon(Icons.person) :
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text('Sewa_connect',)),
                ),
              ),
            ),
            // Drawer items
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context); // close drawer
                // Navigate to home page
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            Divider(), // a line to separate logout
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                // Handle logout
              },
            ),

          ],
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        buttonBackgroundColor: Colors.deepOrange,
        color: Theme.of(context).colorScheme.primary,
        animationDuration: Duration(milliseconds: 280),
        animationCurve: Curves.ease,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
          items: [
            Icon(Icons.home,color: Colors.white,size: 26,),
            Icon(Icons.miscellaneous_services_rounded, color: Colors.white,size: 26,),
            Icon(Icons.person, color: Colors.white,size: 26,),
          ],
          ),
    );
  }
}
