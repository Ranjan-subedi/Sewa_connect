import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/pages/log_in_page.dart';
import 'package:sewa_connect/pages/nav_bar.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool? isLoggedIn;
  String? email;

  Future splashScreen() async {
    isLoggedIn = await SharedPreferencesHelper().getLoginState();
    email = await SharedPreferencesHelper().getEmail();
    print("$email from splash page");
    await Future.delayed(const Duration(seconds: 3));
    print(isLoggedIn);

    if (!mounted) {
      return;
    }

    (isLoggedIn != null && isLoggedIn == true && email != null && email!.isNotEmpty) ?  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),

    ) : Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  @override
  void initState(){
    super.initState();
    splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.black45),
          child: Column(
            children: [
              Lottie.asset('assets/lottie/Sandy_Loading.json',filterQuality: FilterQuality.high, height: 600),
              SizedBox(height: 20),
              Text(
                'Sewa Connect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
