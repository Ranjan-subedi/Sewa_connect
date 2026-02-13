import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sewa_connect/admin/admin_login.dart';
import 'package:sewa_connect/admin/service_add.dart';
import 'package:sewa_connect/firebase_options.dart';
import 'package:sewa_connect/pages/homepage.dart';
import 'package:sewa_connect/pages/nav_bar.dart';
import 'package:sewa_connect/pages/profile.dart';
import 'package:sewa_connect/pages/splash_page.dart';
import 'package:sewa_connect/pages/work_application.dart';
import 'package:sewa_connect/widget/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavBar(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
    );
  }
}
