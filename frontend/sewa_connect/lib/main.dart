import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sewa_connect/component/theme/theme.dart';
import 'package:sewa_connect/pages/homepage.dart';
import 'package:sewa_connect/pages/nav_bar.dart';
import 'package:sewa_connect/pages/profile.dart';
import 'package:sewa_connect/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
    );
  }
}
