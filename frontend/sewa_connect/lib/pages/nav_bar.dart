import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/pages/homepage.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/pages/order_services.dart';
import 'package:sewa_connect/pages/profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List pages;
  late Homepage homepage;
  late ProfilePage profilePage;
  late OrderServicesPage orderServicesPage;

  int _selectedIndex = 0;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homepage = Homepage();
    profilePage = ProfilePage();
    orderServicesPage = OrderServicesPage();

    pages = [
      Homepage(),
      OrderServicesPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
