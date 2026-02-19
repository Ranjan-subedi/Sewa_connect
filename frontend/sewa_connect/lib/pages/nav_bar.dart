import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/pages/homepage.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/pages/my_order.dart';
import 'package:sewa_connect/pages/my_order.dart';
import 'package:sewa_connect/pages/my_order.dart';
import 'package:sewa_connect/pages/order_services.dart';
import 'package:sewa_connect/pages/profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List<Widget> pages;
  late Homepage homepage;
  late ProfilePage profilePage;
  late MyOrderPage myOrderPage;

  int _selectedIndex = 0;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homepage = Homepage();
    profilePage = ProfilePage();
    myOrderPage = MyOrderPage();

    pages = [
      Homepage(),
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
        backgroundColor: Theme.of(context).colorScheme.primary
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('Ranjan Subedi'),
                accountEmail: Text('Ranjansubedi@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('R'),
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
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        color: Theme.of(context).colorScheme.primary,
        animationDuration: Duration(milliseconds: 280),
        animationCurve: Curves.ease,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
          items: [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.person),
          ],
          ),
    );
  }
}
